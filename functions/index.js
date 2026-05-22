const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendDailyWeatherNotification = functions.pubsub
  .schedule("every day 08:00")
  .timeZone("Asia/Bangkok")
  .onRun(async (context) => {
    const db = admin.firestore();
    const messaging = admin.messaging();

    const usersSnapshot = await db.collection("users").get();

    for (const doc of usersSnapshot.docs) {
      const data = doc.data();
      const city = data.notification_city;
      const token = data.fcm_token;

      if (!city || !token) continue;

      try {
        const apiKey = process.env.OPENWEATHER_API_KEY;
        const url = `https://api.openweathermap.org/data/2.5/weather?q=${city}&units=metric&appid=${apiKey}`;

        const response = await fetch(url);
        const weather = await response.json();

        if (weather.cod !== 200) continue;

        const temp = Math.round(weather.main.temp);
        const description = weather.weather[0].description;
        const humidity = weather.main.humidity;
        const windSpeed = weather.wind.speed;

        await messaging.send({
          token: token,
          notification: {
            title: `Weather in ${city}`,
            body: `${temp}°C, ${description}. Humidity: ${humidity}%, Wind: ${windSpeed} m/s`,
          },
          data: {
            city: city,
          },
        });

        console.log(`Notification sent to ${data.email} for ${city}`);
      } catch (error) {
        console.error(`Failed to send to ${data.email}:`, error);
      }
    }

    return null;
  });