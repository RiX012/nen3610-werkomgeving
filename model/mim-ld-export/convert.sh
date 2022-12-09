# Conversion of MIM UML to MIM-LD
# Used for local conversion
# Use pipeline version for automatic conversion in github
# Dependencies:
# - https://github.com/architolk/ea2rdf
# - https://github.com/architolk/rdf2rdf
# - https://github.com/architolk/mimtools
#

# First step: transform native EAP format to RDF
#java -jar ~/GITREPO/ea2rdf/target/ea2rdf.jar -ea -e "../nen3610-2022-template - 20221116.eap" > nen3610-2022-ea.ttl

# Second step: transform EA model in RDF to MIM in RDF
java -jar ~/GITREPO/rdf2rdf/target/rdf2rdf.jar nen3610-2022-ea.ttl nen3610-2022-mim-all.ttl ~/GITREPO/mimtools/ea2mim.yaml

# Third step: get only the NEN3610 Informatimodel from the EA model
java -jar ~/GITREPO/rdf2rdf/target/rdf2rdf.jar nen3610-2022-mim-all.ttl nen3610-2022-mim.ttl nen3610-split.yaml

# Fourth step: transform MIM model in RDF to RDFS/OWL/SHACL ontology
java -jar ~/GITREPO/rdf2rdf/target/rdf2rdf.jar nen3610-2022-mim.ttl nen3610-2022-ont.ttl ~/GITREPO/mimtools/mim2onto.yaml

# Fifth step: create diagram from ontology
#java -jar ~/GITREPO/rdf2xml/target/rdf2xml.jar nen3610-2022-ont.ttl nen3610-2022-model.graphml ~/GITREPO/rdf2xml/rdf2graphml.xsl

# Sixth step: specific NEN3610 steps
java -jar ~/GITREPO/rdf2rdf/target/rdf2rdf.jar nen3610-2022-ont.ttl nen3610-2022-final.ttl nen3610.yaml nen3610-2022-mim.ttl
