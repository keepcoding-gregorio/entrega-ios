//
//  DragonBallAPIDataProvider.swift
//  Dragon BallTests
//
//  Created by Gonzalo Gregorio on 01/10/2023.
//

import XCTest
@testable import Dragon_Ball

final class DragonBallAPIDataProviderTest: XCTestCase {
    
    private var sut: DragonBallAPIDataProvider!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        sut = DragonBallAPIDataProvider(session: URLSession(configuration: configuration))
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testLogin() {
        let expectedToken = "Some Token"
        let someUser = "SomeUser"
        let somePassword = "SomePassword"
        
        MockURLProtocol.requestHandler = { request in
            let loginString = String(format: "%@:%@", someUser, somePassword)
            let loginData = loginString.data(using: .utf8)!
            let base64LogingString = loginData.base64EncodedString()
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Basic \(base64LogingString)")
            
            let data = try XCTUnwrap(expectedToken.data(using: .utf8))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"]
                )
            )
            return (response, data)
        }
        
        let expectation = expectation(description: "Login success")
        
        sut.login(user: someUser, password: somePassword) { result in
            guard case let .success(token) = result else {
                XCTFail("Expected success but received \(result)")
                return
            }
            
            XCTAssertEqual(token, expectedToken)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetCharacters() {
        let expectedCharacters = [CharacterModel(id: "1", name: "Character1", description: "Description1", photo: URL(string: "https://example.com/image1.jpg")!, favorite: false)]
        
        MockURLProtocol.requestHandler = { request in
            let data = try XCTUnwrap(try? JSONEncoder().encode(expectedCharacters))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"]
                )
            )
            return (response, data)
        }
        
        let expectation = expectation(description: "GetCharacters success")
        
        sut.getCharacters { result in
            guard case let .success(characters) = result else {
                XCTFail("Expected success but received \(result)")
                return
            }
            
            XCTAssertEqual(expectedCharacters.count, characters.count)
            XCTAssertEqual(expectedCharacters[0].name, characters[0].name)
            XCTAssertEqual(expectedCharacters[0].description, characters[0].description)
            XCTAssertEqual(expectedCharacters[0].photo, characters[0].photo)

            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetTransformations() {
        let expectedTransformations = [TransformationModel(id: "1", name: "Transformation1", description: "Description1", photo: URL(string: "https://example.com/image1.jpg")!)]
        let character = CharacterModel(id: "1", name: "Character1", description: "Description1", photo: URL(string: "https://example.com/image1.jpg")!, favorite: false)
        
        MockURLProtocol.requestHandler = { request in
            let data = try XCTUnwrap(try? JSONEncoder().encode(expectedTransformations))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"]
                )
            )
            return (response, data)
        }
        
        let expectation = expectation(description: "GetTransformations success")
        
        sut.getTransformations(for: character) { result in
            guard case let .success(transformations) = result else {
                XCTFail("Expected success but received \(result)")
                return
            }
            
            XCTAssertTrue(transformations.count > 0)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }

}

