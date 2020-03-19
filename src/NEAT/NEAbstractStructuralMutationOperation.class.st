Class {
	#name : #NEAbstractStructuralMutationOperation,
	#superclass : #NEAbstractMutationOperation,
	#classVars : [
		'InnovationNumber'
	],
	#category : #NEAT
}

{ #category : #'as yet unclassified' }
NEAbstractStructuralMutationOperation >> performOn: anIndividual [
	InnovationNumber isNil ifTrue: [ InnovationNumber := 1 ].
	InnovationNumber := InnovationNumber + 1.
	super performOn: anIndividual.
]
