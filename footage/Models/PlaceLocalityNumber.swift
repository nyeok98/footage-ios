//
//  PlaceData.swift
//  footage
//
//  Created by 녘 on 2020/07/23.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation

enum Korea: String {
    
    case sejong = "Sejong City"
    case seoul = "Seoul"
    case incheon = "Incheon"
    case busan = "Busan"
    case daegu = "Daegu"
    case ulsan = "Ulsan"
    case daejeon = "Daejeon"
    case gangwon = "Gangwon"
    case gwangju = "Gwangju"
    case gyeonggi = "Gyeonggi-do"
    case jeju = "Jeju"
    case northChungcheong = "North Chungcheong"
    case southChungcheong = "South Chungcheong"
    case northGyeongsang = "North Gyeongsang"
    case southGyeongsang = "South Gyeongsang"
    case northJeolla = "North Jeolla"
    case southJeolla = "South Jeolla"
    //california for test
    case california = "CA"
    
    func cityName() -> String { return self.rawValue }
    
    func cityNameKR() -> String {
        switch self {
        case .sejong: return "세종특별자치시"
        case .seoul: return "서울특별시"
        case .incheon: return "인천광역시"
        case .busan: return "부산광역시"
        case .daegu: return "대구광역시"
        case .ulsan: return "울산광역시"
        case .daejeon: return "대전광역시"
        case .gangwon: return "강원도"
        case .gwangju: return "광주광역시"
        case .gyeonggi: return "경기도"
        case .jeju: return "제주도"
        case .northChungcheong: return "충청북도"
        case .southChungcheong: return "충청남도"
        case .northGyeongsang: return "경상북도"
        case .southGyeongsang: return "경상남도"
        case .northJeolla: return "전라북도"
        case .southJeolla: return "전라남도"
        //california for test
        case .california: return "CA"
        }
    }
    
    func numberOfLocality() -> Double {
        switch self {
        case .sejong: return 19
        case .seoul: return 25
        case .incheon: return 10
        case .busan: return 16
        case .daegu: return 8
        case .ulsan: return 5
        case .daejeon: return 5
        case .gangwon: return 18
        case .gwangju: return 5
        case .gyeonggi: return 31
        case .jeju: return 2
        case .northChungcheong: return 11
        case .southChungcheong: return 15
        case .northGyeongsang: return 23
        case .southGyeongsang: return 18
        case .northJeolla: return 14
        case .southJeolla: return 22
        //california for test
        case .california: return 7
        }
    }
}


