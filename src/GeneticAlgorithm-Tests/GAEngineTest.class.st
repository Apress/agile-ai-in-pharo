Class {
	#name : #GAEngineTest,
	#superclass : #TestCase,
	#category : #'GeneticAlgorithm-Tests'
}

{ #category : #'as yet unclassified' }
GAEngineTest >> testExamples01 [
	| g |
	g := GAEngine new.
	g populationSize: 1000.
	g numberOfGenes: 4.
	g createGeneBlock: [ :rand :index :ind | ($a to: $z) atRandom: rand ].
	g fitnessBlock: [ :genes | 
			(#($g $a $t $o) with: genes collect: [ :a :b | 
				a = b ifTrue: [ 1 ] ifFalse: [ 0 ] ]) sum ].
	g run.
	self assert: g logs first fittestIndividual fitness equals: 2.
	self assert: g logs first fittestIndividual genes equals: #($g $l $t $s).
	self assert: g logs fourth fittestIndividual fitness equals: 4.
	self assert: g logs fourth fittestIndividual genes equals: #($g $a $t $o).
]
