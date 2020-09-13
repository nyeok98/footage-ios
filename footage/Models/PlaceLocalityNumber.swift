//
//  PlaceData.swift
//  footage
//
//  Created by 녘 on 2020/07/23.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation

enum Korea: String {
    
    case sejong = "세종특별자치시"
    case seoul = "서울특별시"
    case incheon = "인천광역시"
    case busan = "부산광역시"
    case daegu = "대구광역시"
    case ulsan = "울산광역시"
    case daejeon = "대전광역시"
    case gangwon = "강원도"
    case gwangju = "광주광역시"
    case gyeonggi = "경기도"
    case jeju = "제주도"
    case northChungcheong = "충청북도"
    case southChungcheong = "충청남도"
    case northGyeongsang = "경상북도"
    case southGyeongsang = "경상남도"
    case northJeolla = "전라북도"
    case southJeolla = "전라남도"
    //california for test
    case california =  "CA"
    
    func cityName() -> String { return self.rawValue }
    
    func cityNameEN() -> String {
        switch self {
        case .sejong : return "Sejong City"
        case .seoul : return "Seoul"
        case .incheon : return "Incheon"
        case .busan : return "Busan"
        case .daegu : return "Daegu"
        case .ulsan : return "Ulsan"
        case .daejeon : return "Daejeon"
        case .gangwon : return "Gangwon"
        case .gwangju : return "Gwangju"
        case .gyeonggi : return "Gyeonggi-do"
        case .jeju : return "Jeju"
        case .northChungcheong : return "North Chungcheong"
        case .southChungcheong : return "South Chungcheong"
        case .northGyeongsang :return "North Gyeongsang"
        case .southGyeongsang : return"South Gyeongsang"
        case .northJeolla : return"North Jeolla"
        case .southJeolla : return"South Jeolla"
        //california for test
        case .california : return"CA"
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


