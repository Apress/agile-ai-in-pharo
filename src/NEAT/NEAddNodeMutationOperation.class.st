Class {
	#name : #NEAddNodeMutationOperation,
	#superclass : #NEAbstractStructuralMutationOperation,
	#category : #NEAT
}

{ #category : #'as yet unclassified' }
NEAddNodeMutationOperation >> on: anIndividual [
	"Add a hidden node and two connections in the individual"
	| relevantConnections c |
	relevantConnections := anIndividual connections select: #isEnabled.
	relevantConnections ifEmpty: [ ^self ].
	
	"We pick a random connection and disable it"
	c := relevantConnections atRandom: anIndividual random.
	c makeDisabled.

	"We add a hidden node ..."
	anIndividual addHiddenNode innovationNumber: InnovationNumber.

	"... and two connections"
	anIndividual addConnection: 
		(NEConnection new in: c in; out: anIndividual numberOfNodesWithBias; weight: 1; makeEnabled; innovationNumber: InnovationNumber).
	anIndividual addConnection: 
		(NEConnection new in: anIndividual numberOfNodesWithBias; out: c out; weight: c weight; makeEnabled; innovationNumber: InnovationNumber).
]
