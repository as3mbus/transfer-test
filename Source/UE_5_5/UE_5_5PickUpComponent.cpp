// Copyright Epic Games, Inc. All Rights Reserved.

#include "UE_5_5PickUpComponent.h"

UUE_5_5PickUpComponent::UUE_5_5PickUpComponent()
{
	// Setup the Sphere Collision
	SphereRadius = 32.f;
}

void UUE_5_5PickUpComponent::BeginPlay()
{
	Super::BeginPlay();

	// Register our Overlap Event
	OnComponentBeginOverlap.AddDynamic(this, &UUE_5_5PickUpComponent::OnSphereBeginOverlap);
}

void UUE_5_5PickUpComponent::OnSphereBeginOverlap(UPrimitiveComponent* OverlappedComponent, AActor* OtherActor, UPrimitiveComponent* OtherComp, int32 OtherBodyIndex, bool bFromSweep, const FHitResult& SweepResult)
{
	// Checking if it is a First Person Character overlapping
	AUE_5_5Character* Character = Cast<AUE_5_5Character>(OtherActor);
	if(Character != nullptr)
	{
		// Notify that the actor is being picked up
		OnPickUp.Broadcast(Character);

		// Unregister from the Overlap Event so it is no longer triggered
		OnComponentBeginOverlap.RemoveAll(this);
	}
}
