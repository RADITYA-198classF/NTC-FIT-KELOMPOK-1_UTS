<?php
return [
    'db' => [
        'host' => getenv('DB_HOST') ?: '127.0.0.1',
        'port' => getenv('DB_PORT') ?: '3306',
        'name' => getenv('DB_NAME') ?: 'ntc_fit_uts',
        'user' => getenv('DB_USER') ?: 'root',
        'pass' => getenv('DB_PASS') ?: '',
    ],
    'app' => [
        'debug' => (getenv('APP_DEBUG') ?: 'true') === 'true',
        // Untuk demo UTS. Di production kode OTP harus dikirim via email/SMS.
        'demo_otp' => getenv('DEMO_OTP') ?: '123456',
    ],
];
