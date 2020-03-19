Class {
	#name : #NormalizationTest,
	#superclass : #TestCase,
	#category : #NeuralNetwork
}

{ #category : #'as yet unclassified' }
NormalizationTest >> testEmptyError [
	self should: [ Normalization new normalizeData: #() ] raise: Error.
]

{ #category : #'as yet unclassified' }
NormalizationTest >> testError [
	self should: [ Normalization new normalizeData: #( #(10 5 1) ) ] raise: Error.
	
]

{ #category : #'as yet unclassified' }
NormalizationTest >> testSimpleNormalization [
	| input expectedNormalizedInput |
	input := #( #(10 5 1) #(2 6 0) ).
	expectedNormalizedInput := Normalization new normalizeData: input.
	self assert: expectedNormalizedInput equals: #(#(1.0 0.0 1) #(0.0 1.0 0))
]
