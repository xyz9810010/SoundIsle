# SoundIsle Provider Contract

## Goal
Every server integration must behave like a replaceable adapter, not a special-case branch spread across the app.

## Required Provider Capabilities
A provider may expose capability flags for:
- browse artists/albums/songs
- search
- cover art
- lyrics plain/synced/structured
- stream original
- transcode
- download
- server favorite/star
- rating
- server playlist CRUD
- scrobble
- play queue sync

## Core Rules
- All remote IDs are strings.
- All DTOs are mapped to Domain models.
- UI never sees provider DTOs.
- PlaybackResolver asks Provider for a fresh AudioSource.
- Provider-specific authentication is contained in the provider/network layer.
- No core UI may branch on server brand for normal behavior.

## Workarounds
Provider quirks belong in a provider compatibility module and must include:
- affected server/version
- reason
- source/verification
- test fixture
- removal condition if known

## Contract Tests
Every First-Class provider must pass:
- happy path
- missing optional fields
- unknown fields
- auth failure
- unsupported capability
- malformed response
- Unicode metadata
- pagination
- stream resolution
