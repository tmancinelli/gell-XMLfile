declare namespace tei="http://www.tei-c.org/ns/1.0";

(: Gets the list of surfaces from the files :)
declare function local:create_surfaces() {
  for $file in doc("a.xml")//file/data(.)
  return doc($file)//tei:facsimile/tei:surface
};

declare function local:create_body_from_file($file as xs:string, $what as xs:string) {
  let $content := doc($file)//tei:text/tei:body/tei:div[@type=$what]/*
  return $content
};

(: Let's create a body text for a particular type :)
declare function local:create_body($what as xs:string) {
  element tei:div {
    attribute type { $what },

    for $file in doc("a.xml")//file/data(.)
    return local:create_body_from_file($file, $what)
  }
};

document {
  <?xml-model href="tei_gell.rng" schematypens="http://relaxng.org/ns/structure/1.0"?>,

  (: Let's create the final TEI document :)
  element tei:TEI {

    (: Here the tei header :)
    element tei:teiHeader {
      element tei:fileDesc {
        element tei:titleStmt {
          element tei:title { "Gell" },

          element tei:respStmt {
            element tei:resp { "Responsabile della codifica" },
            element tei:persName {
              element tei:forename { "Jiangyi" },
              element tei:surname { "Huang" }
            }
          },

          element tei:respStmt {
            element tei:resp { "Responsabile della codifica" },
            element tei:persName {
              element tei:forename { "Milena" },
              element tei:surname { "Jovic" }
            }
          },

          element tei:respStmt {
            element tei:resp { "Responsabile della codifica" },
            element tei:persName {
              element tei:forename { "Patrycja Karolina" },
                element tei:surname { "Pietras" }
            }
          },

          element tei:respStmt {
            element tei:resp { "Supervisione della codifica" },
            element tei:persName {
              element tei:forename { "Tiziana" },
                element tei:surname { "Mancinelli" }
            }
          },

          element tei:respStmt {
            element tei:resp { "Supervisione della codifica" },
            element tei:persName {
              element tei:forename { "Franz" },
                element tei:surname { "Fischer" }
            }
          },

          element tei:respStmt {
            element tei:resp { "Supervisione della codifica" },
            element tei:persName {
              element tei:forename { "Richard" },
                element tei:surname { "Ansell" }
            }
          }
        },

        element tei:publicationStmt {
          element tei:p { "A project by British School at Rome in collaboration with the University of Leicester" }
        },

        element tei:sourceDesc {
          let $listPerson := doc('persons.xml')//tei:listPerson
          return $listPerson,
          let $listPlace := doc('places.xml')//tei:listPlace
          return $listPlace
        }
      }
    },

    (: Surfaces :)
    element tei:facsimile {
      local:create_surfaces()
    },

    (: Here the text :)
    element tei:text {
      element tei:body {
        let $types :=
          for $file in doc("a.xml")//file/data(.)
          return doc($file)//tei:text/tei:body/tei:div/@type

        for $distinctType  in distinct-values($types)
        return local:create_body($distinctType)
      }
    }
  }
}
