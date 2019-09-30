import Foundation

struct SlothWrapper: Codable {
    let sloth: Sloth
}

struct Sloth: Codable {
    let appendages: Int
    let speed: Int
    let name: String
}

//We're used to JSON encoding/decoding.

let ourNewSlothJSON =  """
{
    "sloth": {
        "appendages": 4
        "speed": 3
    }
}
"""

//We make a network call. What type does this come back as?
//Data
//How do we get that data to become an instance of Sloth?
//Decode it.

//the same singleton pattern as UserDefaults.standard

// We're going to look for urls using the SearchPathDirectory enum
// instead of knowing the entire url path to get to a file in that directory, the SearchPathDirectory enum values tell our app where to look.

// example (not really how this works on device)
// on desktop: users/davidrifkin/documents/new-file.txt
// on app: FileManager, go look at the directory with the value .documentationDirectory and get me something called new-file.txt

let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

func filePathFromDocumentsDirectory(name: String) -> URL {
    return documentsDirectory.appendingPathComponent(name)
}

//Serializing = turning your data into a format that can be saved. We've seen Data from the internet serialized as JSON in the past.

let nayeliSloth = Sloth(appendages: 4, speed: 10, name: "Nayeli")
let davidOnMondaySloth = Sloth(appendages: 2, speed: 1, name: "Slowpoke")
let istishnaSloth = Sloth(appendages: 6, speed: 8, name: "Istishna")

let mySloths = [nayeliSloth,davidOnMondaySloth,istishnaSloth]

let slothFileURL = filePathFromDocumentsDirectory(name: "sloths.plist")

func saveSlothsToDocumentsDirectory(sloths: [Sloth]) throws {
    do {
        //this does not encode as Data for a json format. it's specifically used to encode as Data for a Propert List format
        let encodedSloths = try PropertyListEncoder().encode(sloths)
        
        //Create different Data objects
        //encodedSloths = try JSONEncoder().encode(mySloths)

        //Now that it's serialized, let's persist it (save it)
        try encodedSloths.write(to: slothFileURL, options: .atomic)
    } catch {
        throw error
    }
}

//we save
do {
    try saveSlothsToDocumentsDirectory(sloths: mySloths)
} catch {
    print(error)
}

//Look in your file structure and see if there's a file with the path in our URL we created
func getSavedSlothsToDocumentsDirectory() -> [Sloth]? {
    if FileManager.default.fileExists(atPath: slothFileURL.path) {
        //Get the data
        guard let data = FileManager.default.contents(atPath: slothFileURL.path) else {fatalError()}
        
        //Decode the data from the file at that URL
        do {
            let sloths  = try PropertyListDecoder().decode([Sloth].self, from: data)
            return sloths
        } catch {
            print(error)
        }
    }
    return nil
}

//This afternoon, We could abstract this out using...... helpers!
//We could also do this async when saving data!

