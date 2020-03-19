Class {
	#name : #CWorld,
	#superclass : #CVisualElement,
	#instVars : [
		'creatures',
		'time',
		'platforms'
	],
	#category : #Creature
}

{ #category : #'as yet unclassified' }
CWorld >> addCreature: aCreature [
	"Add a creature to the world"
	creatures add: aCreature.

	"Add all the graphical elements of the creature in the view"
	element addAll: (aCreature nodes collect: #element).
	element addAll: (aCreature muscles collect: #element).

	"Move the creature at the initial position"
	aCreature resetPosition.
]

{ #category : #'as yet unclassified' }
CWorld >> addGround [
	"Define the ground of the world"
	| platform |
	platform := CPlatform new width: self groundLength + 500.	
	"We give an extra distance of 500 to make sure there is no issue with the border"
	self addPlatform: platform.
	"The platform is located below where creatures will be initially located"
	platform translateTo: self groundLength / 2 @ 100
]

{ #category : #'as yet unclassified' }
CWorld >> addPlatform: aPlatform [
	"Add a platform to the world"
	platforms add: aPlatform.
	aPlatform createElement.
	element add: aPlatform element.
]

{ #category : #'as yet unclassified' }
CWorld >> addPylons [
	"Add pylons to the world as decorating elements"
	(0 to: self groundLength by: 100)
		do: [ :flagPosition | 
			| pylon |
			pylon := RTBox new
				color: Color green darker;
				width: 3;
				height: 100;
				elementOn: flagPosition.
			element add: pylon.
			pylon @ RTLabeled.
			pylon translateTo: flagPosition @ 50.
			pylon pushBack ]
]

{ #category : #'as yet unclassified' }
CWorld >> beat [
	"Trigger a global beat"
	time := time + 1.
	creatures do: [ :c | c beat; checkForCollision: platforms ]
]

{ #category : #'as yet unclassified' }
CWorld >> createElement [
	"The visual representation of a World is a Roassal view"
	element := RTView new.
]

{ #category : #'as yet unclassified' }
CWorld >> groundLength [
	"Set the length of the ground platform"
	^ 5000
]

{ #category : #'as yet unclassified' }
CWorld >> initialize [
	super initialize.
	creatures := OrderedCollection new.
	platforms := OrderedCollection new.
	time := 0.
	self createElement.
	self addGround
]

{ #category : #'as yet unclassified' }
CWorld >> open [
	"Build the visual representation of the world"
	| lbl animation |
	creatures do: #resetPosition.
	lbl := (RTLabel new elementOn: time) setAsFixed; yourself.
	element add: lbl.
	lbl translateBy: 80 @ 30.
	animation := RTActiveAnimation new
		intervalInMilliseconds: 10;
		blockToExecute: [ | p |
			self beat.
			lbl trachelShape text: time asString.
			p := creatures first position x @ 0.
			element canvas camera translateTo: p.
			element signalUpdate.
			p x > self groundLength
				ifTrue: [ element removeAnimation: animation ] ].
	element addAnimation: animation.
	self addPylons.
	element canvas camera scale: 2.2.
	^ element open
]
