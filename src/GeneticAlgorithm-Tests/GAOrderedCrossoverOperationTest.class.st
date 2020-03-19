Class {
	#name : #GAOrderedCrossoverOperationTest,
	#superclass : #TestCase,
	#instVars : [
		'i1',
		'i2',
		'op'
	],
	#category : #'GeneticAlgorithm-Tests'
}

{ #category : #'as yet unclassified' }
GAOrderedCrossoverOperationTest >> setUp [
    super setUp.
    i1 := GAIndividual new genes: #(8 4 7 3 6 2 5 1 9 0).
    i2 := GAIndividual new genes: #(0 1 2 3 4 5 6 7 8 9).
    op := GAOrderedCrossoverOperation new.
]

{ #category : #'as yet unclassified' }
GAOrderedCrossoverOperationTest >> testCrossover1 [
    | i3 |  
    i3 := op crossover: i1 with: i2 from: 4 to: 8.
    self assert: i3 genes equals: #(0 4 7 3 6 2 5 1 8 9).
]

{ #category : #'as yet unclassified' }
GAOrderedCrossoverOperationTest >> testCrossover2 [
    | i3 |  
    i3 := op crossover: i1 with: i2 from: 1 to: 4.
    self assert: i3 genes equals: #(8 4 7 3 0 1 2 5 6 9).
]

{ #category : #'as yet unclassified' }
GAOrderedCrossoverOperationTest >> testCrossover3 [
    | i3 |  
    i3 := op crossover: i1 with: i2 from: 9 to: 10.
    self assert: i3 genes equals: #(1 2 3 4 5 6 7 8 9 0).
]

{ #category : #'as yet unclassified' }
GAOrderedCrossoverOperationTest >> testCrossover4 [
    | i3 |  
    i1 := GAIndividual new genes: #(1 2 3 4 5 6 7 8 9).
    i2 := GAIndividual new genes: #(9 8 7 6 5 4 3 2 1).

    i3 := op crossover: i1 with: i2 from: 6 to: 8.
    self assert: i3 genes equals: #(9 5 4 3 2 6 7 8 1).               
]
