//
//  MAAPI.swift
//  mala-ios
//
//  Created by 王新宇 on 15/03/2017.
//  Copyright © 2017 Mala Online. All rights reserved.
//

import Foundation
import Moya
import Result

public enum MAAPI {
    case sendSMS(phone: String)
    case verifySMS(phone: String, code: String)
    case profileInfo(id: Int)
    case parentInfo(id: Int)
    case uploadAvatar(data: Data, profileId: Int)
    case saveStudentName(name: String, parentId: Int)
    case saveSchoolName(name: String, parentId: Int)
    case userCoupons(onlyValid: Bool)
    case evaluationStatus(subjectId: Int)
    case getStudentSchedule(onlyPassed: Bool)
    case getOrderList(page: Int)
    case userNewMessageCount()
    case userCollection(page: Int)
    case addCollection(id: Int)
    case removeCollection(id: Int)
    case loadTeacherDetail(id: Int)
    case getTeacherAvailableTime(teacherId: Int, schoolId: Int)
    case getTeacherGradePrice(teacherId: Int, schoolId: Int)
    case getLiveClasses(schoolId: Int?, page: Int)
}

extension MAAPI: TargetType {
    
    // MARK: - TargetType protocol
#if USE_PRD_SERVER
    public var baseURL: URL { return URL(string: "https://www.malalaoshi.com/api/v1")! }
#elseif USE_STAGE_SERVER
    public var baseURL: URL { return URL(string: "https://stage.malalaoshi.com/api/v1")! }
#else
    public var baseURL: URL { return URL(string: "http://dev.malalaoshi.com/api/v1")! }
#endif
    public var path: String {
        switch self {
        case .sendSMS, .verifySMS:
            return "/sms"
        case .profileInfo(let id), .uploadAvatar(_, let id):
            return "/profiles/\(id)"
        case .parentInfo(let id), .saveStudentName(_, let id), .saveSchoolName(_, let id):
            return "/parents/\(id)"
        case .userCoupons:
            return "/coupons"
        case .evaluationStatus(let id):
            return "/subject/\(id)/record"
        case .getStudentSchedule:
            return "/timeslots"
        case .getOrderList:
            return "/orders"
        case .userNewMessageCount:
            return "/my_center"
        case .userCollection, .addCollection:
            return "/favorites"
        case .removeCollection(let id):
            return "/favorites/\(id)"
        case .loadTeacherDetail(let id):
            return "/teachers/\(id)"
        case .getTeacherAvailableTime(let teacherId, _):
            return "teachers/\(teacherId)/weeklytimeslots"
        case .getTeacherGradePrice(let teacherId, let schoolId):
            return "teacher/\(teacherId)/school/\(schoolId)/prices"
        case .getLiveClasses:
            return "/liveclasses"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .sendSMS, .verifySMS, .addCollection:
            return .post
        case .uploadAvatar, .saveStudentName, .saveSchoolName:
            return .patch
        case .removeCollection:
            return .delete
        default:
            return .get
        }
    }
    public var parameters: [String : Any]? {
        switch self {
        case .sendSMS(let phone):
            return ["action": "send", "phone": phone]
        case .verifySMS(let phone, let code):
            return ["action": "verify", "phone": phone, "code": code]
        case .saveStudentName(let name, _):
            return ["student_name": name]
        case .saveSchoolName(let name, _):
            return ["student_school_name": name]
        case .userCoupons(let onlyValid):
            return ["only_valid": String(onlyValid)]
        case .getStudentSchedule(let onlyPassed):
            return ["for_review": String(onlyPassed)]
        case .getOrderList(let page), .userCollection(let page):
            return ["page": page]
        case .addCollection(let id):
            return ["teacher": id]
        case .getTeacherAvailableTime(_, let schoolId):
            return ["school_id": schoolId]
        case .getLiveClasses(let id, let page):
            if let id = id {
                return ["school": id, "page": page]
            }else {
                return ["page": page]
            }
        default:
            return nil
        }
    }
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .sendSMS, .verifySMS, .saveStudentName, .saveSchoolName, .addCollection:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    public var task: Task {
        switch self {
        case .uploadAvatar(let imageData, _):
            return .upload(UploadType.multipart([MultipartFormData(provider: .data(imageData), name: "avatar", fileName: "avatar.jpg", mimeType: "image/jpeg")]))
        default:
            return .request
        }
    }
}

extension MAAPI: AccessTokenAuthorizable {
    public var shouldAuthorize: Bool {
        switch self {
        case .sendSMS, .verifySMS, .getLiveClasses:
            return false
        case .loadTeacherDetail:
            return MalaUserDefaults.isLogined ? true : false
        default:
            return true
        }
    }
}
