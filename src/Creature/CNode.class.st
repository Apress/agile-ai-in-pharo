Class {
	#name : #CNode,
	#superclass : #CVisualElement,
	#instVars : [
		'speedVector',
		'force',
		'isOnPlatform'
	],
	#category : #Creature
}

{ #category : #'as yet unclassified' }
CNode >> addForce: aForceAsPoint [
	"Make the node subject of an external force"
	force := force + aForceAsPoint
]

{ #category : #'as yet unclassified' }
CNode >> beat [
	"Make the node act according to the force and speed applied to the node"
	speedVector := (speedVector + self gravityForce + force) * 0.9.
	isOnPlatform ifTrue: [ 
		speedVector := speedVector x * 0.3 @ speedVector y ].
	self translateBy: speedVector
]

{ #category : #'as yet unclassified' }
CNode >> checkForCollision: platforms [
	"Verify if the node is on a platform. If it is the case, 
	the variable isOnPlatform is set to true"
	isOnPlatform := false.
	platforms
		do: [ :p | 
			(p collide: self)
				ifTrue: [ 
					speedVector := speedVector x @ 0.
					p adjustNodeIfNecessary: self.
					isOnPlatform := true.
					^ self ] ]
]

{ #category : #'as yet unclassified' }
CNode >> createElement [
	element := RTEllipse new size: 10; 
				color: Color gray trans; element.
	element @ RTDraggable	
]

{ #category : #'as yet unclassified' }
CNode >> gravityForce [
	"A fixed force representing a gravity"
	^ 0 @ 0.3
]

{ #category : #'as yet unclassified' }
CNode >> initialize [
	super initialize.
	isOnPlatform := false.
	self resetSpeed.
	self resetForce
]

{ #category : #'as yet unclassified' }
CNode >> isOnPlatform [
	"Is the node on a platform?"
	^ isOnPlatform
]

{ #category : #'as yet unclassified' }
CNode >> position [
	"Return the position of the node"
	^ element position
]

{ #category : #'as yet unclassified' }
CNode >> printOn: str [
	super printOn: str.
	str nextPut: $<.
	str nextPutAll: self hash asString.
	str nextPut: $>.
]

{ #category : #'as yet unclassified' }
CNode >> resetForce [
	"Reset the force exercising on the node"
	force := 0 @ 0
]

{ #category : #'as yet unclassified' }
CNode >> resetSpeed [
	"Make the node stop by canceling its speed"
	speedVector := 0 @ 0
]

{ #category : #'as yet unclassified' }
CNode >> translateBy: aPoint [
	"Translate the node by an incremental point"
	element translateBy: aPoint.
]

{ #category : #'as yet unclassified' }
CNode >> translateTo: aPoint [
	"Translate the node to a new position"
	element translateTo: aPoint.
]
