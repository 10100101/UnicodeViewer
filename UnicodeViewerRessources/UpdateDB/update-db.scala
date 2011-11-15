// Updates the UnicodeViewer DB

object UvdbUpdater {
  import java.sql._


  def openConnection(): Connection = {
    Class.forName("org.sqlite.JDBC")
    DriverManager.getConnection("jdbc:sqlite:UVDB.sqlite")  
  }

  def closeConnection() {
    conn.commit
    conn.close
  }

  val conn = openConnection
  conn.setAutoCommit(false)

  def incrAndGetMaxId(entityName: String): Int ={
    val stat = conn.createStatement 
    val rs = stat.executeQuery("select Z_MAX from Z_PRIMARYKEY where Z_NAME == '"+entityName+"';")
    var maxId = 0;
    if (rs.next) {
      maxId = rs.getInt("Z_MAX")
    }
    stat.executeUpdate("update Z_PRIMARYKEY set Z_MAX = " + (maxId + 1) + " where Z_NAME == '"+entityName+"';")
    stat.close
    return maxId+1
  }

  def insertIfNotExists(c: Int): Boolean = {
    var result = false
    val stat = conn.createStatement
    val rs = stat.executeQuery("select ZVALUE from ZUVCHAR where ZVALUE == " + c + ";")
    if (!rs.next) {
      stat.executeUpdate("insert into ZUVCHAR (Z_PK, Z_ENT, Z_OPT, ZVALUE) values ("+ incrAndGetMaxId("UVChar") +", 2, 1, "+c+");")
      result = true
    }
    stat.close
    return result
  }
  
  def updateDB(start: Int, end: Int) {
    for (c <- start to end) {
      println("Checking " + format("U+%06X", c))
      if (insertIfNotExists(c)) {
        println("Insert " + format("u+%06X", c))
      }
      if (c % 100 == 0) conn.commit
    }
    //closeConnection
  }

  def insertHexValue(start: Int, end: Int) {
    for (c <- start to end) {
      val hexString = format("%X", c)
      println("Updating U+" + hexString)
      val stat = conn.createStatement
      stat.executeUpdate("update ZUVCHAR set ZVALUEHEX = '" + hexString + "' where ZVALUE = "+c+";")
      stat.close
      if (c % 100 == 0) conn.commit
    }
    //closeConnection
  } 

  def updateBlocks() {
    val stat = conn.createStatement
    val rs = stat.executeQuery("select ZNAME, ZRANGELOWER, ZRANGEUPPER from ZUVBLOCK;")
    while (rs.next) {
      println("Updating Block " + rs.getString("ZNAME"))
      updateDB(rs.getInt("ZRANGELOWER"), rs.getInt("ZRANGEUPPER"))
      insertHexValue(rs.getInt("ZRANGELOWER"), rs.getInt("ZRANGEUPPER"))
    }
    stat.close
    closeConnection
  }

  def updateCharRef(value: Int, blockId: Int) {
    val stat = conn.createStatement
    val rs = stat.executeQuery("select Z_PK from ZUVCHAR where ZVALUE = " + value + ";")
    if (rs.next) {
      val charId = rs.getInt("Z_PK")
      println("Updating Char " + charId)
      stat.executeUpdate("update ZUVCHAR set ZBLOCK =" + blockId + " where Z_PK = " + charId + ";")
    }
    rs.close
    stat.close
  }

  def updateBlockChars() {
    val stat = conn.createStatement
    val rs = stat.executeQuery("select Z_PK, ZNAME, ZRANGELOWER, ZRANGEUPPER from ZUVBLOCK;")
    while (rs.next) {
      println("Updating Block " + rs.getString("ZNAME"))
      for (v <- rs.getInt("ZRANGELOWER") to rs.getInt("ZRANGEUPPER")) updateCharRef(v, rs.getInt("Z_PK"))
    }
    rs.close
    stat.close
    closeConnection
  }

  def charIdWithValue(value: Int): Option[Int] = {
    val stat = conn.createStatement
    val rs = stat.executeQuery("select Z_PK from ZUVCHAR where ZVALUE = " + value + ";")
    var charId = -1
    if (rs.next) {
      charId = rs.getInt("Z_PK")
    }
    rs.close
    stat.close
    if (charId > 0) return Some(charId) else return None
  }

  def updateRelatedChars(fileName: String) {
    def updateRelatedCharForChar(charId: Int)(relatedValue: Int) {
      charIdWithValue(relatedValue) match {
        case Some(relatedCharId) => {
          val stat = conn.createStatement
          val pk = incrAndGetMaxId("UVRelatedChars")
          stat.executeUpdate("insert into ZUVRELATEDCHARS (Z_PK, Z_ENT, Z_OPT, ZRELATED, ZCHARINFO) values ("+pk+", 4, 1, "+relatedCharId+", "+charId+");")
          stat.executeUpdate("update ZUVCHAR set ZRELATEDPARENT = "+relatedCharId+" where Z_PK = "+charId+";")
          println(charId + " -> " + relatedValue + " ("+relatedCharId+")");
          conn.commit
        } 
        case None => {println("Related char with value " + relatedValue + " not found")}
      }
    }

    def updateRelatedChar(charTuple: (Int, List[Int])) {
      println("Inserting " + charTuple._1)
      charIdWithValue(charTuple._1) match {
        case Some(charId) => {
          charTuple._2.foreach(updateRelatedCharForChar(charId))
        }
        case None => {println("Char with value " + charTuple._1 + " not found")}
      }
    }
    NameListParser.parseFile(fileName).foreach(updateRelatedChar)
    closeConnection
  }
}

object NameListParser {

  def parseFile(fileName: String): List[(Int, List[Int])] = {
    import scala.io.Source
    var result : List[(Int, List[Int])] = List()
    var relatedChars : List[Int] = List()
    var currentChar : Int = -1
    val lines = Source.fromFile(fileName).getLines
    while (lines.hasNext) {
      val line = lines.next
      if (line.length > 3 && line.indexOf('\t') > 0 && line.substring(0,line.indexOf('\t')).matches("[0-9a-zA-Z]{4,6}")) {
        if (!relatedChars.isEmpty) {
          result = result :+ (currentChar, relatedChars)
          relatedChars = List()
        }
        currentChar = parseIntHex(line.substring(0,line.indexOf('\t')))
      }
      if (line.length > 1 && line.substring(1,2).equals("x")) {
        if ("(".equals(line.substring(3,4))) {
          relatedChars = relatedChars :+ parseIntHex(line.substring(line.lastIndexOf('-')+2, line.length-1))
        } else {
          relatedChars = relatedChars :+ parseIntHex(line.substring(3))
        }
      }
    }
    return result
  }

  def parseIntHex(value: String) = Integer.parseInt(value, 16)

}
//NameListParser.parseFile("NamesList.txt").foreach(println)
UvdbUpdater.updateRelatedChars("NamesList.txt")

