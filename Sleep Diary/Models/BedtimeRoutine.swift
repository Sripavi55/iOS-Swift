import Foundation

struct BedtimeRoutine: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var time: Date

    init(
        id: UUID = UUID(),
        title: String,
        time: Date
    ) {
        self.id = id
        self.title = title
        self.time = time
    }
}
