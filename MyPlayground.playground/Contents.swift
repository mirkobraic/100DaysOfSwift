import UIKit

class Selo {
    var name: String
    var rows: [String]
    
    init(name: String, rows: [String]) {
        self.name = name
        self.rows = rows
    }
}

var a: [Selo] = [Selo(name: "Omis", rows: ["a1", "a2", "a3"]), Selo(name: "Livno", rows: [])]

var b = a

a[0].rows.remove(at: 0)

print(a[0].rows.first)
print(b[0].rows.first)

b = []

print(a.count)
print(b.count)
