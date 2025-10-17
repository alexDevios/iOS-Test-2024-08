//
//  DummyInteractor.swift
//  iOS-Test
//

// Implemented by Interactor
protocol DummyBusinessLogic {
  // Loads the list of the items and passes Load.Response to Presenter
  func load(request: DummyModels.Load.Request)
}

class DummyInteractor {
  var presenter: DummyPresentationLogic?
}

extension DummyInteractor: DummyBusinessLogic {
  func load(request: DummyModels.Load.Request) {
    presenter?.present(response: .init())
  }
}
