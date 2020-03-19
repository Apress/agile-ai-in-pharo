Class {
	#name : #GAAbstractMutationOperation,
	#superclass : #GAOperation,
	#instVars : [
		'mutationRate'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
GAAbstractMutationOperation >> doMutate: individual [
	"To be overridden"
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
GAAbstractMutationOperation >> geneFactoryBlock: oneArgBlock [
	"Do nothing. May be overridden if necessary"
]

{ #category : #'as yet unclassified' }
GAAbstractMutationOperation >> initialize [
	super initialize.
	self mutationRate: 0.01
]

{ #category : #'as yet unclassified' }
GAAbstractMutationOperation >> mutate: individual [
	"Return a new individual (different object than the argument), result of a mutation from the individual provided as argument."
	| newIndividual |
	newIndividual := GAIndividual new.
	newIndividual random: random.
	newIndividual genes: individual genes copy.
	self doMutate: newIndividual.
	^ newIndividual
]

{ #category : #'as yet unclassified' }
GAAbstractMutationOperation >> mutationRate [
	"Return the used mutation rate. Typically, a small positive number, close to 0.0 and significantly less than 1.0"
	^ mutationRate
]

{ #category : #'as yet unclassified' }
GAAbstractMutationOperation >> mutationRate: aFloat [
	"Set the mutation rate. Typically, a small positive number, close to 0.0 and significantly less than 1.0"
	mutationRate := aFloat
]
