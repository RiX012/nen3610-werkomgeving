# Generatie van de MIM ontologie

De MIM ontologie wordt volledig gegenereerd vanuit het EA bestand in de map `/model`. De generatie gaat via de volgende stappen:

1. Eerst wordt het originele EA bestand omgezet in triples, conform het metamodel van EA zelf;
2. Vervolgens wordt het bestand uit stap 1 omgezet in een MIM-LD specificatie, zoals beschreven in [hoofdstuk 4 van de MIM standaard](https://docs.geostandaarden.nl/mim/mim/#metamodel-in-linked-data-ld). Dit resultaat-bestand ([nen3610-2022-mim.ttl](/model/mim-ld-export/nen3610-2022-mim.ttl)) is een exportformaat van het MIM NEN3610-model, onafhankelijk van tools zoals EA.
3. Tenslotte wordt het bestand uit stap 2 omgezet in een Ontologie in RDFS/OWL/SHACL, conform de transformatie zoals beschreven in [sectie 6.4 van de MIM standaard](https://docs.geostandaarden.nl/mim/mim/#transformatie-mim-rdfs-owl-shacl). Dit resultaat-bestand ([nen3610-2022-ontologie.ttl](/model/nen3610-2022-ontologie.ttl)) beschrijft de NEN3610 ontologie die in Linked Data toepassingen kan worden gebruikt.

## Afwijkingen ten opzichte van de MIM transformatie-standaard

Bij de transformatie van het NEN3610 MIM model naar RDFS/OWL/SHACL is zo strikt mogelijk voldaan aan de regels zoals gedefinieerd in de MIM standaard. Toch is het noodzakelijk gebleken om enkele afwijkingen c.q. aanvullingen toe te passen. In een enkel geval gaat het om een interpretatie van de standaard, waarbij de standaard niet (volledig) precies is in de keuze die gemaakt moet worden. In andere gevallen gaat het om informatie die benodigd was om de transformatie uit te voeren, maar niet aanwezig was in de standaard. Daarnaast is er één geval waarbij er feitelijk geen onduidelijkheid is, maar waar het toch wenselijk is om een toelichting te geven op de uiteindelijke transformatie.

### Interpretaties

1. Er is gekozen om afwijkende URI's op te nemen voor de sh:NodeShapes en owl:Classes. In de standaard wordt dit ook ondersteund, zonder dat expliciet wordt gemaakt dat de URI's moeten verschillen.
2. We zijn er vanuit gegaan dat mim:identificerend alleen de waarde 'true' heeft, en in alle andere gevallen ontbreekt.
3. In de uiteindelijke ontologie hebben we ook nog de MIM elementen bijgevoegd, conform de transformatieregel "het element <> wordt direct, zonder aanpassing, overgenomen in het vertaalde model". Dit om de leesbaarheid van het uiteindelijke model te verhogen. We hebben niet gekozen om gebruik te maken van het meta-element `mim:equivalent`.

### Afwijkingen en toevoegingen

1. De URI's voor de element in de ontologie zijn niet afkomstig uit het model zelf, maar handmatig toegevoegd. Hoewel in sectie 6.4 wel een transformatieregel is opgenomen hoe de URI gevormd zou kunnen worden op basis van metagegevens van een package, zijn dergelijke metagegevens niet aanwezig in de huidige standaard zelf (hoofdstuk 4). Voor de sh:PropertyShapes is gekozen voor blank nodes.
2. Voor CodeList hebben we handmatig de link met de waarden uit de codelist opgenomen. Hiervoor is in de standaard nog geen mogelijkheid beschreven om dit goed te transformeren.
3. Voor de drie groepen attribuutsoorten m.b.t. metagegevens van historie is nog geen goede manier beschikbaar om aan te geven dat elk van de groepen gebruikt kan worden. In het EA model is hiervoor een extra stereotype gebruikt, in de ontologie is dit handmatig omgezet (aangezien dergelijke stereotypen niet tot de MIM standaard behoren).

#### Codelijst 'VoidReasonValue'

```
nen3610-ont:Waardelijsten
        a            owl:Ontology ;
        owl:imports  <https://definities.geostandaarden.nl/rest/v1/nen3610-2022/data?uri=http%3A%2F%2Fdefinities.geostandaarden.nl%2Fnen3610-2022%2Fid%2Fcollectie%2Fmogelijk_geen_waarde&format=text/turtle> .

nen3610:VoidReasonValue
        a                            owl:Class ;
        rdfs:subClassOf              skos:Concept .

nen3610-sh:VoidReasonValue
        a                            sh:NodeShape ;
        sh:Property                  [ sh:hasValue  nen3610-col:mogelijk_geen_waarde ;
                                       sh:path      [ sh:inversePath  skos:member ]
                                     ] ;
        sh:targetClass               nen3610:VoidReasonValue .
```

De werking van deze constructie is als volgt:
- Met de `owl:import` wordt verzorgd dat de juiste waarden worden geïmporteerd. De URI die hier gebruikt wordt, levert daadwerkelijk de betreffende waarden op dit moment. Wellicht beter zou zijn om een 'doc' URI van de collectie te kunnen gebruiken, maar deze is op dit moment niet beschikbaar. De waarde is afkomstig uit het metagegeven `mim:locatie`;
- Met `rdfs:subClassOf` is duidelijk dat de waarden niet "zomaar" exemplaren zijn, maar referenties naar begrippen;
- Met `sh:hasValue` wordt aangegeven dat de begrippen in een specifieke collectie moeten voorkomen (via het inverse pad `skos:member`)

Hiermee is de werking van de Codelijst voor het grootste gedeelte gelijk getrokken met de werking van de Enumeratie. Enige uitdaging is nu nog dat de locatie van de waarden wel bekend zijn, maar niet de daadwerkelijke constraint. In dit geval is gekeken naar de waarden in een `skos:Collection`, maar er zijn ook situaties dat in zo'n geval het `skos:ConceptScheme` is gebruikt. Op dit moment is dat nog niet uit het MIM informatiemodel af te leiden.

#### Metagegevens rondom historie

Omdat er feitelijk geen gegevensconstraints worden toegevoegd bij de ordening van de properties rondom historie, kan volstaan worden met het introduceren van drie PropertyGroups.

```
nen3610-sh:TijdlijnGeldigheid
        a           sh:PropertyGroup ;
        rdfs:label  "TijdlijnGeldigheid" .

nen3610-sh:TijdlijnRegistratie
        a           sh:PropertyGroup ;
        rdfs:label  "TijdlijnRegistratie" .

nen3610-sh:Levensduur
        a           sh:PropertyGroup ;
        rdfs:label  "Levensduur" .

nen3610-sh:Registratie
  sh:property [
               sh:group  nen3610-sh:TijdlijnRegistratie ;
               sh:path   nen3610:tijdstipRegistratie
              ] ;
  sh:property [
                sh:group  nen3610-sh:TijdlijnRegistratie ;
                sh:path   nen3610:eindRegistratie
              ] ;
  sh:property [
                sh:group  nen3610-sh:TijdlijnGeldigheid ;
                sh:path   nen3610:beginGeldigheid
              ] ;
  sh:property [
                sh:group  nen3610-sh:TijdlijnGeldigheid ;
                sh:path   nen3610:eindGeldigheid
              ] ;
  sh:property [
               sh:group  nen3610-sh:Levensduur ;
               sh:path   nen3610:objectEindTijd
              ] ;
  sh:property [
                sh:group  nen3610-sh:Levensduur ;
                sh:path   nen3610:objectBeginTijd
              ] .
```

### Toelichtingen

#### Naam van eigenschap afkomstig uit een relatie

In UML bestaat de mogelijkheid om bij een relatie zowel een relatiesoortnaam als een relatierolnaam op te geven. Voor MIM geldt dat één van de twee namen daarbij daadwerkelijk de drager van informatie is, de andere is puur ter ondersteuning. De MIM-transformatieregels zijn hierover duidelijk: als er een rolnaam is ingevuld, dan moet alleen deze meegenomen worden in de transformatie. Dit kan daardoor eventueel afwijken van het metagegeven `mim:relatiemodelleringstype` (mocht daar de waarde `mim:relatiesoortLeidend` zijn gebruikt). Dit lijkt een inconsistentie in de MIM standaard. In het specifieke geval van dit NEN 3610 informatiemodel is er geen onduidelijkheid, omdat het metagegeven `mim:relatiemodelleringstype` in dit geval de waarde `mim:relatierolLeidend` heeft. Dit sluit ook aan bij de tekst in de NEN 3610 standaard zelf (sectie 7.5): "*[..]gebruikt bij het modelleren van relaties tussen objecttypen de relatie-einden (bron en doel) als informatiedragers. De naam van de relatie is alleen voor de leesbaarheid van het model.*". Dit geldt ook voor partijen die gebruik maken van de NEN 3610 standaard, uit dezelfde sectie: "*NEN 3610 conformeert zich aan het Metamodel voor Informatiemodellering (MIM). Toepassingen van NEN3610 conformeren zich daarmee ook aan MIM.*".

Partijen die een eigen Linked Data model gebruiken kunnen vanzelfsprekend zelf aanvullende eigenschappen toevoegen (bijvoorbeeld door in de implementatie gebruik te maken van `rdfs:subPropertyOf`). Voor de leesbaarheid bij de uitwisseling van data wordt dan wel geadviseerd om alsnog de originele NEN 3610 eigenschappen toe te voegen, om te voorkomen dat derden de data niet rechtstreeks kunnen lezen conform het originele informatiemodel). Dit is niet nodig voor de subklassen van het NEN 3610 model, aangezien dit al duidelijk wordt vanuit het model zelf (dergelijke subklassen zullen in originele informatiemodel via een generalisatie zichtbaar zijn) Zie onderstaand voorbeeld waarin een dergelijke uitbreiding is toegepast (zowel op klassen als eigenschappen):

```
  # Model
  imvoorbeeld:Brug rdfs:subClassOf nen3610:Kunstwerk.
  imvoorbeeld:geregistreerdMet rdfs:subPropertyOf nen3610:registratiegegevens.

  # Data
  brug:Merwedebrug a imvoorbeeld:Brug;
    imvoorbeeld:geregistreerdMet brugdata:MerwedebrugRegistratie-20220125185426;
    nen3610:registratiegegevens brugdata:MerwedebrugRegistratie-20220125185426;
  .
  brugdata:MerwedebrugRegistratie-20220125185426 a nen3610:Registratie;
    nen3610:tijdstipRegistratie "2022-01-25T18:54:26"^^xsd:dateTime;
  .
```
