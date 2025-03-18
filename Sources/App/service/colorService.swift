import Foundation
import NIOCore

final class ColorService {
    private let roomRepo: any RoomRepoProtocol
    private let colorRepo: any ColorRepoProtocol

    init(roomRepo: any RoomRepoProtocol, colorRepo: any ColorRepoProtocol) {
        self.colorRepo = colorRepo
        self.roomRepo = roomRepo

    }

    func getThemeColors(roomID: RoomID) async throws -> [Color] {
        let colorIDsFuture: EventLoopFuture<[ColorID]> = try await colorRepo.findColorIDsByRoomID(roomID: roomID)
        let colorIDs: [ColorID] = try await colorIDsFuture.get()
        var themeColors: [Color] = []

        for colorID: ColorID in colorIDs {
            if let color: Color = try await colorRepo.findThemeColorByColorID(colorID: colorID).get() {
                themeColors.append(color)
            }
        }
        return themeColors
    }
}
