package com.example.kmmnative

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform