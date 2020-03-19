Class {
	#name : #MNAbstractCharacter,
	#superclass : #Object,
	#instVars : [
		'position',
		'jumpNbSteps',
		'phase',
		'game',
		'isFalling',
		'isJumping'
	],
	#category : #MiniMario
}

{ #category : #'as yet unclassified' }
MNAbstractCharacter >> beat [
	"Execute a unit of behavior"
	isJumping ifTrue: [ 
		phase == #goingUp ifTrue: [ self translateBy: 0 @ -1 ].
		phase == #doingDown ifTrue: [ self translateBy: 0 @ 1 ].
		jumpNbSteps := jumpNbSteps + 1.
		jumpNbSteps = 5 ifTrue: [ phase := #doingDown ].
		jumpNbSteps = 10 ifTrue: [ isJumping := false ] ].
	
	isJumping ifFalse: [ 
		self isThereAPlatformBelowMe 
			ifTrue: [ 
				self setAsFalling.
				self translateBy: 0 @ 1 ]
			ifFalse: [ self setAsNotFalling ] ].
]

{ #category : #'as yet unclassified' }
MNAbstractCharacter >> canGoToward: aDeltaPosition [
	"Return true if the character can go toward a direction"
	^ (game getCellAt: position + aDeltaPosition) = 0
]

{ #category : #'as yet unclassified' }
MNAbstractCharacter >> game: aWorldGame [
	"Set the world in which I live"
	game := aWorldGame
]

{ #category : #'as yet unclassified' }
MNAbstractCharacter >> initialize [
	super initialize.
	isJumping := false.
	position := 0 @ 0.
	isFalling := true.
]

{ #category : #'as yet unclassified' }
MNAbstractCharacter >> isThereAPlatformBelowMe [
	"Return true if there is no platform below the character"
	^ (game getCellAt: self position + (0 @ 1)) = 0
]

{ #category : #'as yet unclassified' }
MNAbstractCharacter >> jump [
	"Make the character jump"
	"Do nothing if it is jumping or falling"
	isJumping ifTrue: [ ^ self ].
	isFalling ifTrue: [ ^ self ].
	isJumping := true.
	phase := #goingUp.
	jumpNbSteps := 0.
]

{ #category : #'as yet unclassified' }
MNAbstractCharacter >> moveLeft [
	"Make the character move left"
	self translateBy: -1 @ 0
]

{ #category : #'as yet unclassified' }
MNAbstractCharacter >> moveRight [
	"Make the character move right"
	self translateBy: 1 @ 0
]

{ #category : #'as yet unclassified' }
MNAbstractCharacter >> position [
	"Return the position of the character"
	^ position
]

{ #category : #'as yet unclassified' }
MNAbstractCharacter >> setAsFalling [
	"Set the character as falling"
	isFalling := true
]

{ #category : #'as yet unclassified' }
MNAbstractCharacter >> setAsNotFalling [
	"Set the character as not falling"
	isFalling := false
]

{ #category : #'as yet unclassified' }
MNAbstractCharacter >> translateBy: aDeltaPosition [
	"Translate the character by a delta, if possible"
	(self canGoToward: aDeltaPosition) ifFalse: [ ^ self ].
	position := position + aDeltaPosition
]

{ #category : #'as yet unclassified' }
MNAbstractCharacter >> translateTo: aPosition [
	"Set a position of the character"
	position := aPosition
]
