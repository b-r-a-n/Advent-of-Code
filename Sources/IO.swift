import Darwin

struct IOError: Error
{
  let number: Int32
  let message: String
}

typealias Byte = UInt8

func ReadEntireFile(at path: String) throws -> [Byte]
{
  let fd = open(path, O_RDONLY)
  guard fd >= 0 else {
    let e = errno
    throw IOError(number: e, message: String(cString: strerror(e)))
  }
  defer { close(fd) }
  var bytes: [UInt8] = []
  let buffSize = 4096
  var buff = Array<Byte>(repeatElement(0, count: buffSize))
  var bytesRead = 0
  repeat {
    bytesRead = read(fd, &buff, buffSize)
    bytes += buff.prefix(bytesRead)
  } while bytesRead > 0
  return bytes
}
