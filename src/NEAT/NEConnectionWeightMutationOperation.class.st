Class {
	#name : #NEConnectionWeightMutationOperation,
	#superclass : #NEAbstractNonStructuralMutationOperation,
	#category : #NEAT
}

{ #category : #'as yet unclassified' }
NEConnectionWeightMutationOperation >> on: anIndividual [
	"Modify the weight of a connection"
	| c |
	anIndividual connections ifEmpty: [ ^ self ].
	c := (anIndividual connections atRandom: random).
	c weight: self randomWeight + c weight
]
