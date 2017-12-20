//
//  ComplexDemoViewController.swift
//  ExpandableCell
//
//  Created by Andrey Zonov on 18/10/2017.
//  Copyright © 2017 Andrey Zonov. All rights reserved.
//

import UIKit
import AZExpandable

class ComplexDemoViewController: UIViewController {
    
    // MARK: IBOutlet's
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Private Properties
    private var expandableTable: ExpandableTable!
    private var expandedCell: ExpandedCellInfo?
    private var tableViewModel = TableViewModelFactory.staticExpandableTable
    private var pickerController: PickerItemsController?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CellFactory.registerCells(for: tableView)
        expandableTable = ExpandableTable(with: tableView, infoProvider: self)
        // DataSource and Delegate for PickerView, closure is about value changing
        pickerController = PickerItemsController { title in
            if let indexPath = self.expandedCell?.indexPath {
                var viewModel = self.tableViewModel.cell(for: indexPath)
                viewModel.title = title
                self.tableViewModel.replace(cell: viewModel, at: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    private func toggleItem(at indexPath: IndexPath) {
        guard expandedCell?.indexPath != indexPath else {
            expandableTable.unexpandCell()
            expandedCell = nil
            return
        }
        let cellViewModel = tableViewModel.sections[indexPath.section].cells[indexPath.row]
        let cellType: ExpandedCellInfo.CellType
        switch cellViewModel.expandingType {
        case .date:
            cellType = .datePicker { datePicker in
                datePicker.minimumDate = Date()
                datePicker.addTarget(self.pickerController,
                                     action: #selector(PickerItemsController.datePickerDidChangeValue),
                                     for: .valueChanged)
            }
            
        case .picker:
            cellType = .picker { picker in
                picker.dataSource = self.pickerController
                picker.delegate = self.pickerController
            }
            
        case .custom:
            cellType = .custom { [weak self] indexPath -> (UITableViewCell) in
                let centeredCell = self?.tableView.dequeueReusableCell(withIdentifier: "CenteredLabelCell",
                                                                       for: indexPath) as! CenteredLabelCell
                centeredCell.configure(with: "Hint Inside your custom cell")
                centeredCell.backgroundColor = .lightGray
                return centeredCell
            }
        }
        let cell = ExpandedCellInfo(for: indexPath, cellType: cellType)
        expandedCell = cell
        expandableTable.expandCell(cell)
    }
}

// MARK: - UITableViewDataSource
extension ComplexDemoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = tableViewModel.sections[section]
        return section.title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewModel.sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableViewModel.sections[indexPath.section].cells[indexPath.row]
        do {
            return try CellFactory.cell(for: cellModel, in: tableView, indexPath: indexPath) { [weak self] in
                self?.toggleItem(at: indexPath)
            }
        } catch {
            assertionFailure("handle \(error)")
            return UITableViewCell(style: .default, reuseIdentifier: "default")
        }
    }
}

// MARK: - UITableViewDelegate
extension ComplexDemoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleItem(at: indexPath)
    }
}
