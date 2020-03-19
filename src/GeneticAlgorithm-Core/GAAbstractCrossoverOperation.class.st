Class {
	#name : #GAAbstractCrossoverOperation,
	#superclass : #GAOperation,
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
GAAbstractCrossoverOperation >> crossover: partnerA with: partnerB [
	"Return a new child, which is the result of mixing myself with the argument"
	^ self crossover: partnerA with: partnerB midpoint: (self pickCutPointFor: partnerA)
]

{ #category : #'as yet unclassified' }
GAAbstractCrossoverOperation >> crossover: partnerA with: partnerB midpoint: midpoint [
	"Return a new child, which is the result of mixing myself with the argument"

	| child crossOverGenes |
	child := GAIndividual new.
	child random: random.
	crossOverGenes := (partnerA genes first: midpoint)
		, (partnerB genes allButFirst: midpoint).
	child genes: crossOverGenes.
	^ child
]

{ #category : #'as yet unclassified' }
GAAbstractCrossoverOperation >> pickCutPointFor: anIndividual [
	"Need to be overridden in subclasses"
	self subclassResponsibility 
]
