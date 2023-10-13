//
//  FilterPetsContentViewController+Types.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit

//MARK: - Types
extension FilterPetsContentViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Section: Int {
        case type
        case gender
        case size
        case ageRange
        case address
        case end
    }
    
    enum Item: Hashable {
        case type(FilterPetsType)
        case gender(FilterPetsGender)
        case size(FilterPetsSize)
        case ageRange(FilterPetsAge)
        case address(FilterPetsAddress)
        case end(FilterPetsSend)
    }
    
    struct SnapData {
        var key: Section
        var values: [Item]
    }
}

enum FilterType: String, Codable, Hashable {
    case all
    case dog
    case cat
    case bird
    case rabbit
}

enum FilterGender: String, Codable, Hashable {
    case all
    case male
    case female
}

enum FilterSize: String, Codable, Hashable {
    case all
    case small
    case medium
    case large
}

enum FilterState: String, Codable, Hashable, CaseIterable {
    case AllCountry
    case Aguascalientes
    case BajaCalifornia = "Baja California"
    case BajaCaliforniaSur = "Baja California Sur"
    case Campeche
    case Chiapas
    case Chihuahua
    case Coahuila
    case Colima
    case Durango
    case Guanajuato
    case Guerrero
    case Hidalgo
    case Jalisco
    case MexicoCity = "Ciudad de Mexico"
    case MexicoState = "Estado de Mexico"
    case Michoacan
    case Morelos
    case Nayarit
    case NuevoLeon = "Nuevo Leon"
    case Oaxaca
    case Puebla
    case Queretaro
    case QuintanaRoo = "Quintana Roo"
    case SanLuisPotosi = "San Luis Potosi"
    case Sinaloa
    case Sonora
    case Tabasco
    case Tamaulipas
    case Tlaxcala
    case Veracruz
    case Yucatan
    case Zacatecas
}

struct FilterOptions {
    let type: Pet.PetType?
    let gender: Pet.Gender?
    let size: Pet.Size?
    let address: Pet.State?
}
