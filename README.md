# Doctor Booking App

Flutter + Supabase based doctor-patient booking app.

## App Flow (Step by Step)

### 1. Doctor Side: Register and Login
1. Open the app and go to the user login screen.
2. Tap `Register as Doctor`.
3. If doctor account is not registered:
   Use `Sign Up` with email and password.
4. If doctor account is already registered:
   Use `Login` with email and password.

### 2. Doctor Side: Add Doctor Profile
1. After first successful doctor auth, open doctor registration/profile setup.
2. Add doctor details (name, specialization, experience, fee, bio, image).
3. Save doctor profile.

### 3. Doctor Side: Set Availability
1. Open doctor `Availability` screen.
2. Enable available days.
3. Set start and end time for each active day.
4. Save availability settings.

### 4. User Side: Login with Phone OTP
1. Open user login.
2. Enter phone number.
3. Tap `Send OTP`.
4. Enter OTP and verify.
5. After successful login, user can continue into app features.

### 5. User Side: Book Appointment
1. Open doctor list / doctor details.
2. Select date and time from available slots.
3. Enter patient details and problem description.
4. Confirm payment / booking.
5. Appointment is created in the system.

### 6. Appointment Status Handling
- `pending` or `booked`: shown in Upcoming for user.
- `confirmed` (doctor approved): moved to Past for user and shown as Approved.
- `rejected` (canceled): moved to Past for user and shown as Canceled.

## Tech Stack
- Flutter
- Supabase Auth + Database + Storage
- BLoC state management

## Architecture
This project follows **Clean Architecture** with clear feature-based separation:

- `presentation`: UI, pages, widgets, BLoC
- `domain`: entities, repositories (contracts), use cases
- `data`: datasource implementations, models, repository implementations

Each feature is organized independently (Doctor/User/Auth/Appointment/etc.) to keep code modular, testable, and scalable.

## Architecture
This project follows **Clean Architecture** with clear feature-based separation:

- `presentation`: UI, pages, widgets, BLoC
- `domain`: entities, repositories (contracts), use cases
- `data`: datasource implementations, models, repository implementations

Each feature is organized independently (Doctor/User/Auth/Appointment/etc.) to keep code modular, testable, and scalable.

## Run Locally
1. Install Flutter SDK.
2. Run:
   ```bash
   flutter pub get
   flutter run
   ```
