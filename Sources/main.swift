import Darwin

// -d preceeds day parameter
// -i preceeds the input path

func main(args: [String])
{
  guard
    let dayIdx = args.index(of: "-d"),
    let pathIdx = args.index(of: "-i"),
    dayIdx + 1 < args.count,
    pathIdx + 1 < args.count,
    let day = Int(args[dayIdx + 1])
  else {
    print("Expect -i {input file path} and -d {day} parameters")
    return
  }
  let path = args[pathIdx + 1]
  switch day {
  case 1: Day1.main(pathToInput: path)
  default: print("Day \(day) not implemented")
  }
}

main(args: CommandLine.arguments)
