//
//  SearchTrainPresenter.swift
//  MyTravelHelper
//
//  Created by Satish on 11/03/19.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

class SearchTrainPresenter: ViewToPresenterProtocol {
    
    var stationsList:[Station] = [Station]()

    func searchTapped(source: String, destination: String) {
        let sourceStationCode = getStationCode(stationName: source)
        let destinationStationCode = getStationCode(stationName: destination)
        interactor?.fetchTrainsFromSource(sourceCode: sourceStationCode, destinationCode: destinationStationCode)
    }
    
    func favoriteStationTapped(stationId: Int) -> Bool {
        let favStationId = UserDefaults.standard.integer(forKey: DefaultsKeys.FAVORITE_STATION)
        if stationId == favStationId {
            UserDefaults.standard.set(0, forKey: DefaultsKeys.FAVORITE_STATION)
            return false
        } else {
            UserDefaults.standard.set(stationId, forKey: DefaultsKeys.FAVORITE_STATION)
            return true
        }
    }
    
    var interactor: PresenterToInteractorProtocol?
    var router: PresenterToRouterProtocol?
    var view:PresenterToViewProtocol?

    func fetchallStations() {
        interactor?.fetchallStations()
    }

    private func getStationCode(stationName:String)->String {
        let stationCode = stationsList.filter{$0.stationDesc == stationName}.first
        return stationCode?.stationCode.lowercased() ?? ""
    }
}

extension SearchTrainPresenter: InteractorToPresenterProtocol {
    func showNoInterNetAvailabilityMessage() {
        view!.showNoInterNetAvailabilityMessage()
    }

    func showNoTrainAvailbilityFromSource() {
        view!.showNoTrainAvailbilityFromSource()
    }

    func fetchedTrainsList(trainsList: [StationTrain]?) {
        if let _trainsList = trainsList, _trainsList.count > 0 {
            view!.updateLatestTrainList(trainsList: _trainsList)
        } else {
            view!.showNoTrainsFoundAlert()
        }
    }
    
    func stationListFetched(list: [Station]) {
        stationsList = list
        view!.saveFetchedStations(stations: list)
    }
}
