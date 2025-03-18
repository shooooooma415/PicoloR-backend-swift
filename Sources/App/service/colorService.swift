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
        // roomID に紐づく ColorID の一覧を取得
        let colorIDs: EventLoopFuture<> = try await colorRepo.findColorIDsByRoomID(roomID: roomID)
        var themeColors: [Color] = []

        // 各 ColorID に対してテーマカラーを個別に取得
        for colorID in colorIDs {
            if let color = try await colorRepo.findThemeColorByColorID(colorID: colorID) {
                themeColors.append(color)
            }
        }
        return themeColors
    }
}
