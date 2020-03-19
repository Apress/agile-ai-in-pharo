Class {
	#name : #GAMutationOperationTest,
	#superclass : #TestCase,
	#instVars : [
		'i',
		'op'
	],
	#category : #'GeneticAlgorithm-Tests'
}

{ #category : #'as yet unclassified' }
GAMutationOperationTest >> setUp [
	super setUp.
	i := GAIndividual new genes: 'abcd' asArray.
	op := GAMutationOperation new.
]

{ #category : #'as yet unclassified' }
GAMutationOperationTest >> testMutation [
	| i2 |	
	op random: (Random seed: 7).
	op geneFactoryBlock: [ :r | ($a to: $z) atRandom: r ].
	op mutationRate: 0.5.
	
	i2 := op mutate: i.
	self assert: i2 genes equals: 'xfcd' asArray.
	
	i2 := op mutate: i2.
	self assert: i2 genes equals: 'tfcd' asArray.
	
	i2 := op mutate: i2.
	self assert: i2 genes equals: 'tfjd' asArray.
]

{ #category : #'as yet unclassified' }
GAMutationOperationTest >> testRandomAndGeneFactoryMustBeSet [
	self should: [ op mutate: i ] raise: AssertionFailure.
	
	op random: Random new.
	self should: [ op mutate: i ] raise: AssertionFailure.
	
	op geneFactoryBlock: [ :r | 42 ].
	self shouldnt: [ op mutate: i ] raise: AssertionFailure.
]
