//
//  ViewController.swift
//  EmployeeDirectory
//
//  Created by Thomas Chin on 4/21/22.
//

import UIKit
import Combine

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var subscriptions = Set<AnyCancellable>()

    private var viewModel: DirectoryViewModel!
    
//    var list: [Employee] = []
    var navBar: UINavigationController!
    var tableView: UITableView!
    var tableRefresh: UIRefreshControl!
    
    let urlString = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DirectoryViewModel.init()

//        setupBindings()
        
        setupTableView()
        setupRefreshControl()
        fetchEmployeeData()
        setupNavigationBar()
    
    }
    
//
//    func setupBindings() {
//        subscriptions = [
//            viewModel.$employees.assign(to: \.list, on: self)
//        ]
//    }
//
//
    
    func setupNavigationBar() {
        navigationItem.title = "Contacts"
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:.black]
    }

    func fetchEmployeeData() {
        viewModel.fetchEmployeeData(url: urlString) {(newEmployeeList, error) in
            guard error == nil else {
                print(error ?? "Error fetching employee data")
                return
            }
            
            DispatchQueue.main.sync {
                for employee in newEmployeeList! {
                    self.viewModel.addEmployee(newEmployee: employee)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func setupRefreshControl() {
        tableRefresh = UIRefreshControl()
        
        tableRefresh.tintColor = .gray
        tableRefresh.addTarget(self, action: #selector(handleRefreshList(_:)), for: .valueChanged)
        
        self.tableView.refreshControl = tableRefresh
    }
    
    @objc func handleRefreshList(_ tableRefresh: UIRefreshControl) {
            viewModel.clearEmployeeList()
            fetchEmployeeData()
            tableRefresh.endRefreshing()
        }
    
    
    
    func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.register(EmployeeTableViewCell.self,
                           forCellReuseIdentifier: "EmployeeTableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell", for: indexPath) as! EmployeeTableViewCell
        let employeeData = viewModel.employees[indexPath.row]
        cell.nameLabel.text = employeeData.fullName
        cell.teamLabel.text = employeeData.teamName
        cell.emailLabel.text = employeeData.emailAddress
        cell.profileImageView.loadImage(urlString: employeeData.smallPhotoUrl)
        
        return cell
    }
    
    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(viewModel.employees[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 100
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView.init()
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//
//        let title = UILabel()
//        title.text = "Employee Directory"
//        title.textColor = .black
//        title.font = UIFont.boldSystemFont(ofSize: 18)
//
//        headerView.addSubview(title)
//        title.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
//        title.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -15).isActive = true
//        title.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
//        title.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
//        title.translatesAutoresizingMaskIntoConstraints = false
//
//        return headerView
//    }
}

