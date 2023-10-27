//
//  FilterPetsViewModel.swift
//  pethug
//
//  Created by Raul Pena on 09/10/23.
//

import UIKit
import Firebase
import Combine

class FilterPetsViewModel {
    
    init() {
        setInitialValues()
        observeValidation()
    }

    //MARK: - Form Validation
    private var cancellables = Set<AnyCancellable>()
    @Published var genderState:   FilterGender  = .all
    @Published var sizeState:     FilterSize   = .all
    @Published var ageRangeState: FilterAgeRange  = .init(min: 0, max: 25)
    @Published var addressState:  FilterState?   = nil
    
    var isValidSubject = CurrentValueSubject<Bool, Never>(false)
    var stateSubject = PassthroughSubject<LoadingState, Never>()
    
    var filterOptions: FilterOptions!
    private var currentFilterOptions: FilterOptions? = nil
    private var filterKey = "filterOptions"
    
    private func observeValidation() {
            formValidationState
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .valid:
                    self?.isValidSubject.send(true)
                case .invalid:
                    self?.isValidSubject.send(false)
                }
            }).store(in: &cancellables)
    }
    
    private var formValidationState: AnyPublisher<State, Never> {
        return Publishers.CombineLatest(
            Publishers.CombineLatest($ageRangeState, $addressState),
            Publishers.CombineLatest($genderState, $sizeState)
        )
        .map { [weak self] nameGalleryType, breedGenderSize in
            guard let self = self else { return .invalid }
            
            let (ageRange, address) = nameGalleryType
            let (gender, size) = breedGenderSize
            createFilterOptions(
                gender: gender,
                size: size,
                ageRange: ageRange,
                address: address
            )
            return self.validateForm(
                gender: gender,
                size: size,
                ageRange: ageRange,
                address: address
            )
        }
        .eraseToAnyPublisher()
    }
    
    private func validateForm(
        gender: FilterGender,
        size: FilterSize,
        ageRange: FilterAgeRange,
        address: FilterState?
    ) -> State{
        if let currentFilterOptions = currentFilterOptions {
            let options = FilterOptions(
                gender: gender,
                size: size,
                age: ageRange,
                address: address
            )
            
            if currentFilterOptions == options {
                return .invalid
            } else {
                return .valid
            }
        }
         
        if gender != .all ||
           size   != .all ||
           address != nil {
            return .valid
        }
        
        if ageRange.min != 0 ||
           ageRange.max != 25 {
                return .valid
        }
        
        return.invalid
    }
    
    
    private func createFilterOptions(
        gender: FilterGender,
        size: FilterSize,
        ageRange: FilterAgeRange,
        address: FilterState?
    ) {
        let options = FilterOptions(
                        gender: gender,
                        size: size,
                        age: ageRange,
                        address: address
                    )
        filterOptions = options
    }
    
    private func setInitialValues() {
        if let savedFilterOptions = retrieveFilterOptionsFromUserDefaults() {
            currentFilterOptions = savedFilterOptions
            
            genderState   = savedFilterOptions.gender
            sizeState     = savedFilterOptions.size
            ageRangeState = savedFilterOptions.age
            addressState  = savedFilterOptions.address
        }
    }
    
    private func saveFilterOptionsToUserDefaults() {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(filterOptions)
            UserDefaults.standard.set(encodedData, forKey: filterKey)
        } catch {
            print("Error saving filter options to UserDefaults: \(error)")
        }
    }
    
    private func retrieveFilterOptionsFromUserDefaults() -> FilterOptions? {
        if let encodedData = UserDefaults.standard.data(forKey: filterKey) {
            do {
                let decoder = JSONDecoder()
                let options = try decoder.decode(FilterOptions.self, from: encodedData)
                return options
            } catch {
                print("Error decoding filter options from UserDefaults: \(error)")
            }
        }
        return nil
    }
    
    //MARK: - Public methods
    func saveFilterOptions() {
        saveFilterOptionsToUserDefaults()
    }
    
    func resetState() {
        genderState   = .all
        sizeState     = .all
        ageRangeState = .init(min: 0, max: 25)
        addressState  = nil
        
        isValidSubject.send(true)
    }
    
}



