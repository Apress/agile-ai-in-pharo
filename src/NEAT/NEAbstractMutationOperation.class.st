Class {
	#name : #NEAbstractMutationOperation,
	#superclass : #Object,
	#instVars : [
		'random'
	],
	#category : #NEAT
}

{ #category : #'as yet unclassified' }
NEAbstractMutationOperation >> on: anIndividual [
	"Override this method to perform the mutation"
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
NEAbstractMutationOperation >> performOn: anIndividual [
	"Public method that perform a mutation on the argument
	 the method modifies anIndividual"
	random := anIndividual random.
	anIndividual resetFitness.
	self on: anIndividual 
]

{ #category : #'as yet unclassified' }
NEAbstractMutationOperation >> random: aRandomNumberGenerator [
	random := aRandomNumberGenerator
]

{ #category : #'as yet unclassified' }
NEAbstractMutationOperation >> randomWeight [
	"Return a random number within -5 and 5"
	^ random next * 10 - 5
]
