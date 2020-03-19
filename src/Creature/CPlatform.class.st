Class {
	#name : #CPlatform,
	#superclass : #CVisualElement,
	#instVars : [
		'width',
		'height'
	],
	#category : #Creature
}

{ #category : #'as yet unclassified' }
CPlatform >> adjustNodeIfNecessary: node [
	"Answer whether the platform collide the node"
	| bottomNode topPlatform |
	bottomNode := node element encompassingRectangle bottomCenter y.
	topPlatform := self element encompassingRectangle topCenter y.

	topPlatform < bottomNode 
		ifTrue: [ node translateBy: 0 @ (topPlatform - bottomNode) ]
]

{ #category : #'as yet unclassified' }
CPlatform >> collide: node [
	"Answer whether the platform collide with the node argument"
	^ node element encompassingRectangle intersects: self element encompassingRectangle
]

{ #category : #'as yet unclassified' }
CPlatform >> createElement [
	"Create the visual representation of a platform"
	element ifNotNil: [ "already created" ^ self ].
	element := RTBox new width: width; height: height; color: Color gray; element.
]

{ #category : #'as yet unclassified' }
CPlatform >> height: aHeightAsNumber [
	"Set the height of the platform"
	height := aHeightAsNumber
	
]

{ #category : #'as yet unclassified' }
CPlatform >> initialize [
	super initialize.
	self width: 100.
	self height: 10
]

{ #category : #'as yet unclassified' }
CPlatform >> translateTo: aPosition [
	"Translate the platform to a particular position"
	self createElement.
	element translateTo: aPosition
]

{ #category : #'as yet unclassified' }
CPlatform >> width: aWidthAsNumber [
	"Set the width of the platform"
	width := aWidthAsNumber
]
