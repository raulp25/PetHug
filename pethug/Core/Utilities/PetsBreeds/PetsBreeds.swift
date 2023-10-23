//
//  PetsBreeds.swift
//  pethug
//
//  Created by Raul Pena on 22/10/23.
//

import Foundation

let dog_breeds = [
    "Affenpinscher",
    "Airedale terrier",
    "Akita",
    "Akita americano",
    "Alaskan Husky",
    "Alaskan malamute",
    "American Foxhound",
    "American pit bull terrier",
    "American staffordshire terrier",
    "Ariegeois",
    "Artois",
    "Australian silky terrier",
    "Australian Terrier",
    "Austrian Black & Tan Hound",
    "Azawakh",
    "Balkan Hound",
    "Basenji",
    "Basset Alpino",
    "Basset Artesiano Normando",
    "Basset Azul de Gascuña ",
    "Basset de Artois",
    "Basset de Westphalie",
    "Basset Hound",
    "Basset Leonado de Bretaña",
    "Bavarian Mountain Scenthound",
    "Beagle",
    "Beagle Harrier",
    "Beauceron",
    "Bedlington Terrier",
    "Bichon Boloñes",
    "Bichón Frisé",
    "Bichón Habanero",
    "Billy",
    "Black and Tan Coonhound",
    "Bloodhound",
    "Bobtail",
    "Boerboel",
    "Border Collie",
    "Border terrier",
    "Borzoi",
    "Bosnian Hound",
    "Boston terrier",
    "Bouvier des Flandres",
    "Boxer",
    "Boyero de Appenzell",
    "Boyero de Australia",
    "Boyero de Entlebuch",
    "Boyero de las Ardenas",
    "Boyero de Montaña Bernes",
    "Braco Alemán de pelo corto",
    "Braco Alemán de pelo duro",
    "Braco de Ariege",
    "Braco de Auvernia",
    "Braco de Bourbonnais",
    "Braco de Saint Germain",
    "Braco Dupuy",
    "Braco Francés",
    "Braco Italiano",
    "Broholmer",
    "Buhund Noruego",
    "Bull terrier",
    "Bulldog americano",
    "Bulldog inglés",
    "Bulldog francés",
    "Bullmastiff",
    "Ca de Bestiar",
    "Cairn terrier",
    "Cane Corso",
    "Cane da Pastore Maremmano-Abruzzese",
    "Caniche",
    "Caniche Toy",
    "Cao da Serra de Aires",
    "Cao da Serra de Estrela",
    "Cao de Castro Laboreiro",
    "Cao de Fila de Sao Miguel",
    "Cavalier King Charles Spaniel",
    "Cesky Fousek",
    "Cesky Terrier",
    "Chesapeake Bay Retriever",
    "Chihuahua",
    "Chin",
    "Chow Chow",
    "Cirneco del Etna",
    "Clumber Spaniel",
    "Cocker Spaniel Americano",
    "Cocker Spaniel Inglés",
    "Collie Barbudo",
    "Collie de Pelo Cort",
    "Collie de Pelo Largo",
    "Cotón de Tuléar",
    "Curly Coated Retriever",
    "Dálmata",
    "Dandie dinmont terrier",
    "Dachshund",
    "Deerhound",
    "Dobermann",
    "Dogo Argentino",
    "Dogo de Burdeos",
    "Dogo del Tibet",
    "Drentse Partridge Dog",
    "Drever",
    "Dunker",
    "Elkhound Noruego",
    "Elkhound Sueco",
    "English Foxhound",
    "English Springer Spaniel",
    "English Toy Terrier",
    "Epagneul Picard",
    "Eurasier",
    "Fila Brasileiro",
    "Finnish Lapphound",
    "Flat Coated Retriever",
    "Fox terrier de pelo de alambre",
    "Fox terrier de pelo liso",
    "Foxhound Inglés",
    "French Poodle",
    "Frisian Pointer",
    "Galgo Español",
    "Galgo húngaro",
    "Galgo Italiano",
    "Galgo Polaco",
    "Glen of Imaal Terrier",
    "Golden Retriever",
    "Gordon Setter",
    "Gos d'Atura Catalá",
    "Gran Basset Griffon Vendeano",
    "Gran Boyero Suizo",
    "Gran Danés",
    "Gran Gascón Saintongeois",
    "Gran Griffon Vendeano",
    "Gran Munsterlander",
    "Gran Perro Japonés",
    "Grand Anglo Francais Tricoleur",
    "Grand Bleu de Gascogne",
    "Greyhound",
    "Griffon Bleu de Gascogne",
    "Griffon de pelo duro",
    "Griffon leonado de Bretaña",
    "Griffon Nivernais",
    "Grifon Belga",
    "Grifón de Bruselas",
    "Haldenstoever",
    "Harrier",
    "Hokkaido",
    "Hovawart",
    "Husky Siberiano",
    "Ioujnorousskaia Ovtcharka",
    "Irish Glen of Imaal terrier",
    "Irish soft coated wheaten terrier",
    "Irish terrier",
    "Irish Water Spaniel",
    "Irish Wolfhound",
    "Jack Russell terrier",
    "Jindo Coreano",
    "Kai",
    "Keeshond",
    "Kelpie australiano",
    "Kerry blue terrier",
    "King Charles Spaniel",
    "Kishu",
    "Komondor",
    "Kooiker",
    "Kromfohrländer",
    "Kuvasz",
    "Labrador Retriever",
    "Lagotto Romagnolo",
    "Laika de Siberia Occidental",
    "Laika de Siberia Oriental",
    "Laika Ruso Europeo",
    "Lakeland terrier",
    "Landseer",
    "Lapphund Sueco",
    "Lebrel Afgano",
    "Lebrel Arabe",
    "Leonberger",
    "Lhasa Apso",
    "Lowchen",
    "Lundehund Noruego",
    "Malamute de Alaska",
    "Maltés",
    "Manchester terrier",
    "Mastiff",
    "Mastín de los Pirineos",
    "Mastín Español",
    "Mastín Napolitano",
    "Mudi",
    "Norfolk terrier",
    "Norwich terrier",
    "Nova Scotia duck tolling retriever",
    "Ovejero alemán",
    "Otterhound",
    "Rafeiro do Alentejo",
    "Ratonero Bodeguero Andaluz",
    "Retriever de Nueva Escocia",
    "Rhodesian Ridgeback",
    "Ridgeback de Tailandia",
    "Rottweiler",
    "Saarloos",
    "Sabueso de Hamilton",
    "Sabueso de Hannover",
    "Sabueso de Hygen",
    "Sabueso de Istria",
    "Sabueso de Posavaz",
    "Sabueso de Schiller",
    "Sabueso de Smaland",
    "Sabueso de Transilvania",
    "Sabueso del Tirol",
    "Sabueso Español",
    "Sabueso Estirio de pelo duro",
    "Sabueso Finlandés",
    "Sabueso Francés blanco y negro",
    "Sabueso Francés tricolor",
    "Sabueso Griego",
    "Sabueso Polaco",
    "Sabueso Serbio",
    "Sabueso Suizo",
    "Sabueso Yugoslavo de Montaña",
    "Sabueso Yugoslavo tricolor",
    "Salchicha",
    "Saluki",
    "Samoyedo",
    "San Bernardo",
    "Sarplaninac",
    "Schapendoes",
    "Schipperke",
    "Schnauzer estándar",
    "Schnauzer gigante",
    "Schnauzer miniatura",
    "Scottish terrier",
    "Sealyham terrier",
    "Segugio Italiano",
    "Seppala Siberiano",
    "Setter Inglés",
    "Setter Irlandés",
    "Setter Irlandés rojo y blanco",
    "Shar Pei",
    "Shiba Inu",
    "Shih Tzu",
    "Shikoku",
    "Skye terrier",
    "Slovensky Cuvac",
    "Slovensky Kopov",
    "Smoushond Holandés",
    "Spaniel Alemán",
    "Spaniel Azul de Picardía",
    "Spaniel Bretón",
    "Spaniel de Campo",
    "Spaniel de Pont Audemer",
    "Spaniel Francés",
    "Spaniel Tibetano",
    "Spinone Italiano",
    "Spítz Alemán",
    "Spitz de Norbotten",
    "Spitz Finlandés",
    "Spitz Japonés",
    "Staffordshire bull terrier",
    "Staffordshire terrier americano",
    "Sussex Spaniel",
    "Tchuvatch eslovaco",
    "Terranova",
    "Terrier australiano",
    "Terrier brasilero",
    "Terrier cazador alemán",
    "Terrier checo",
    "Terrier galés",
    "Terrier irlandés",
    "Terrier japonés",
    "Terrier negro ruso",
    "Terrier tibetano",
    "Tosa",
    "Viejo Pastor Inglés",
    "Viejo Pointer Danés",
    "Vizsla",
    "Volpino Italiano",
    "Weimaraner",
    "Welsh springer spaniel",
    "Welsh Corgi Cardigan",
    "Welsh Corgi Pembroke",
    "Welsh terrier",
    "West highland white terrier",
    "Whippet",
    "Wirehaired solvakian pointer",
    "Xoloitzcuintle",
    "Yorkshire Terrier"
]

let cat_breeds = [
    "Abisinio",
    "Angora turco",
    "American curl",
    "American Shorthair",
    "American wirehair",
    "Azul ruso",
    "Balines",
    "Bengalí",
    "Bobtail japonés",
    "Bombay",
    "Bosque de Noruega",
    "British Shorthair",
    "Burmese",
    "California spangled",
    "Chartreux o Cartujo",
    "Cornish rex",
    "Devon Rex",
    "Exótico",
    "Habana",
    "Himalayo",
    "Javanés",
    "Korat",
    "Maine coon",
    "Manx",
    "Mau egipcio",
    "Nibelungo",
    "Ocicat",
    "Oriental de pelo corto",
    "Persa",
    "Ragdoll",
    "Scottish fold",
    "Selkirk rex",
    "Siamés",
    "Singapur",
    "Snowshoe",
    "Somalí",
    "Sphynx",
    "Tiffanie",
    "Tonkinés",
    "Van turco"
]


let bird_breeds = [
    "Pajaro",
    "Águila",
    "Búho",
    "Buitre",
    "Colibrí",
    "Cisne",
    "Cuervo",
    "Flamenco",
    "Garza",
    "Gaviota",
    "Golondrina",
    "Gorriones",
    "Loro",
    "Mirlo",
    "Pato",
    "Paloma Doméstica",
    "Perico",
    "Pavo Real",
    "Tucán"
]


let rabbit_breeds = [
    "American",
    "American chinchilla",
    "American sable",
    "Amfuzzylop smallB",
    "Belgian hare",
    "Beveren",
    "Britannian petite",
    "Californian small",
    "Champagne dargent",
    "Checkered giant",
    "Cinnamon",
    "Creme dargent",
    "Dutch small",
    "Dwarfhotot",
    "English angora",
    "Englishspot",
    "Englop small",
    "Flemish giant",
    "Florida white",
    "Francés angora",
    "Francés lop small",
    "Gigante angora",
    "Gigante chinchilla",
    "Harlequin small",
    "Havana",
    "Himalayan",
    "Hollandlop small",
    "HototJ",
    "Jersey woolyL",
    "Lilac",
    "Minilop small",
    "Minirex",
    "Netherland dwarf",
    "Newzeland small",
    "Palomino",
    "Polish small",
    "Rex",
    "Rhynelander",
    "Saint angora",
    "Satin",
    "Silver",
    "Silver fox",
    "Silver marten",
    "Standard chinchilla",
    "Tan"
]
