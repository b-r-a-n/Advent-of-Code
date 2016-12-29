struct Day1
{

  private enum Instruction
  {
    case left(Int)
    case right(Int)

    static func decode(_ bytes: [Byte]) -> Instruction?
    {
      var creator: ((Int) -> Instruction)? = nil
      var buff = ""
      for byte in bytes {
        let char = Character(UnicodeScalar(byte))
        switch char {
        case "L": creator = Instruction.left
        case "R": creator = Instruction.right
        case "0"..."9": buff.append(char)
        default: break
        }
      }
      guard let makeInstruction = creator else { return nil }
      return Int(buff).map(makeInstruction)
    }

  }

  private enum Direction
  {
    case North, East, South, West

    mutating func turn(left: Bool)
    {
      switch self {
      case .North: self = left ? .West : .East
      case .East: self = left ? .North : .South
      case .South: self = left ? .East : .West
      case .West: self = left ? .South : .North
      }
    }
  }

  private static func Offset(_ coordinate: (x: Int, y: Int), by distance: Int, direction: Direction) -> (Int, Int)
  {
    var result = coordinate
    switch direction {
    case .North: result.y += distance
    case .East: result.x += distance
    case .South: result.y -= distance
    case .West: result.x -= distance
    }
    return result
  }

  private static func part1(_ instructions: [Instruction]) -> Int
  {
    var direction: Direction = .North
    var coordinate = (x: 0, y: 0)
    instructions.forEach { instruction in
      switch instruction {
      case .left(let d):
        direction.turn(left: true)
        coordinate = Offset(coordinate, by: d, direction: direction)
      case .right(let d):
        direction.turn(left: false)
        coordinate = Offset(coordinate, by: d, direction: direction)
      }
    }
    return abs(coordinate.x) + abs(coordinate.y)
  }

  private static func part2(_ instructions: [Instruction]) -> Int
  {
    var direction: Direction = .North
    var coordinate = (x: 0, y:0)
    var visited: [(x: Int, y: Int)] = []
    instructions.forEach { instruction in
      var distance = 0
      switch instruction {
      case .left(let d):
        distance = d
        direction.turn(left: true)
      case .right(let d):
        distance = d
        direction.turn(left: false)
      }
      for _ in 0..<distance {

        if visited.contains(where: { coordinate.x == $0.x && coordinate.y == $0.y }) {
          break
        }
        visited.append(coordinate)
        coordinate = Offset(coordinate, by: 1, direction: direction)
      }
    }
    return abs(coordinate.x) + abs(coordinate.y)
  }

  private static func parse(_ pathToInput: String) -> [Instruction]?
  {
    do {
      let input = try ReadEntireFile(at: pathToInput)
      var instructions: [Instruction] = []
      var buff: [Byte] = []
      for byte in input {
        let char = Character(UnicodeScalar(byte))
        switch char {
        case ",":
          Instruction.decode(buff).map { instructions.append($0) }
          buff.removeAll()
        case " ": break
        default: buff.append(byte)
        }
      }
      if buff.count > 0 {
        Instruction.decode(buff).map { instructions.append($0) }
        buff.removeAll()
      }
      return instructions
    } catch {
      print(error)
      return nil
    }
  }

  static func main(pathToInput: String)
  {
    guard let instructions = parse(pathToInput) else {
      print("Error parsing file")
      return
    }
    print(part1(instructions))
    print(part2(instructions))
  }
}
