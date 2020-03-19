Class {
	#name : #GAIndividualTest,
	#superclass : #TestCase,
	#category : #'GeneticAlgorithm-Tests'
}

{ #category : #'as yet unclassified' }
GAIndividualTest >> testCreationWithCharacters [
	| r individuals f ind |
	r := Random seed: 42.
	f := [ :random | ($a to: $z) atRandom: random ].
	individuals := GAIndividual
		create: 100
		individualsAndInitialize: 10
		genesWith: f
		using: r.
		
	self assert: individuals size equals: 100.
	self assert: (individuals collect: #numberOfGenes) asSet asArray equals: #(10).

	ind := individuals anyOne.
	self assert: (ind genes allSatisfy: [ :c | ($a to: $z) includes: c ]).
]
