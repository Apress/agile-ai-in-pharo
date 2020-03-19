Class {
	#name : #CVisualElement,
	#superclass : #Object,
	#instVars : [
		'element'
	],
	#category : #Creature
}

{ #category : #'as yet unclassified' }
CVisualElement >> createElement [
	"Should be overridden in subclasses. 
	The method initializes the element variable"
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
CVisualElement >> element [
	"Return the Roassal element"
	^ element
]
