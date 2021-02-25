//
// Created by Андрей Кривобок on 17.12.2020.
//

import Foundation
import SwiftDate

struct TimeSlot: Equatable, Hashable {
    var service: Service
    var start: Date

    var end: Date {
        start.dateByAdding(service.duration, .minute).date
    }
}

extension TimeSlot {
    public var beginTimeString: String {
        let dateFormatter = DateFormatter.sharedFormatter(forRegion: .current, format: "HH:mm")
        return dateFormatter.string(from: start)
    }

    public var endTimeString: String {
        let dateFormatter = DateFormatter.sharedFormatter(forRegion: .current, format: "HH:mm")
        return dateFormatter.string(from: end)
    }

}

struct DateSlot: Equatable, Hashable {
    var date: Date
    var timeSlots: [TimeSlot] = []
}

extension DateSlot {

    var dateString: String {
        date.toString(.custom("EEEE, dd MMMM"))
    }

    var description: String {
        timeSlots.count > 0 ? R.string.localizable.appointmentsNearestTimeToAppointment()
                : R.string.localizable.appointmentsHasNoTimeToAppointment()
    }
}

struct ScheduleSection: Equatable, Hashable {
    var service: Service
    var dateSlots: [DateSlot] = []
    var id: Int { service.id }

    init(service: Service, workSlots: [WorkSlot]) {
        self.service = service

        let workSlotsWithService = workSlots.filter { $0.description?
                .components(separatedBy: .punctuationCharacters)
                .map { Int($0) }
                .contains(service.id) ?? false } //{ $0.services?.contains(service) ?? true } // TODO: replace true with false
        let scheduleSlots = workSlotsWithService.filter { $0.status == .schedule }
        let occupiedSlots = workSlots.filter { $0.status == .booked || $0.status == .confirmed }
        let timeSlots: [TimeSlot] = scheduleSlots.reduce(into: []) { (result: inout [TimeSlot], slot: WorkSlot) in
            var nextTime = slot.beginDateTime
            while let nextTimeSlot = self.nextTimeSlot(for: nextTime, in: slot, with: service.duration, occupiedSlots: occupiedSlots) {
                result.append(nextTimeSlot)
                nextTime = nextTimeSlot.end
            }
        }
        let timeSlotsGroupedByDate = Dictionary(grouping: timeSlots) { $0.start.dateAt(.startOfDay) }
        dateSlots = timeSlotsGroupedByDate.map { date, timeSlots in
            DateSlot(date: date, timeSlots: timeSlots)
        }.sorted(by: { $0.date.isBeforeDate($1.date, granularity: .day)})

        if !(dateSlots.first?.date.isToday ?? false) {
            dateSlots.insert(DateSlot(date: Date().dateAtStartOf(.day)), at: 0)
        }
    }
    
    private func nextTimeSlot(for beginTime: Date, in workSlot: WorkSlot, with duration: Int, occupiedSlots: [WorkSlot]) -> TimeSlot? {
        let endTime = beginTime.dateByAdding(duration, .minute).date
        guard beginTime.isBeforeDate(workSlot.endDateTime, granularity: .minute) &&
                endTime.isBeforeDate(workSlot.endDateTime, orEqual: true, granularity: .minute) else {
            return nil
        }
        let inOccupied = occupiedSlots.filter({
            ($0.beginDateTime..<$0.endDateTime).contains(beginTime) ||
                ($0.beginDateTime.dateByAdding(1, .minute).date...$0.endDateTime).contains(endTime)
        })
        if inOccupied.count > 0, let nextVacantTime = inOccupied.map({ $0.endDateTime }).max() {
            return nextTimeSlot(for: nextVacantTime, in: workSlot, with: duration, occupiedSlots: occupiedSlots)
        }
        
        return TimeSlot(service: service, start: beginTime)
    }
}

extension ScheduleSection {

    var title: String {
        service.name
    }

    var duration: String {
        R.string.localizable.minutes(count: service.duration)
    }
}

struct Schedule: Equatable {
    var sections: [ScheduleSection] = []

    init(services: [Service], workSlots: [WorkSlot]) {
        sections = services.map { ScheduleSection(service: $0, workSlots: workSlots) }
    }
}

struct AppointmentsState: Equatable {
    var patientProfile: PatientProfile
    var doctorProfile: DoctorProfile
    var workSlots: [Int:WorkSlot]?
    var appointments: [WorkSlot]?
    var schedule: Schedule?
    var selectedTimeSlot: TimeSlot?
    var createAppointmentState: CreateAppointmentState?
    var expandedSectionId: Int?


    var view: AppointmentsView.ViewState {
        AppointmentsView.ViewState(createAppointmentPresented: createAppointmentState != nil)
    }

    var badgeNumber = 0
}