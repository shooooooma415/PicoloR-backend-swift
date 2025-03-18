import Vapor

typealias ColorCode = String
typealias ColorID = Int

struct Color: Content {
    let colorId: ColorID
    let colorCode: ColorCode
    let roomID: RoomID
}

struct CreateColor: Content{
    let colorCode: [ColorCode]
    let roomID: RoomID
}

struct getColorRes: Content{
    let colorID: ColorID
    let colorCode: ColorCode
}

struct GetColorResponse: Content{
    let themeColor: [getColorRes]
}