﻿using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json.Serialization;

namespace HomeAutio.Mqtt.GoogleHome.App_Start
{
    /// <summary>
    /// JSON Serializer configuration.
    /// </summary>
    public static class JsonSerializerConfig
    {
        /// <summary>
        /// Configure the JSON Serializer.
        /// </summary>
        public static void Configure()
        {
            JsonConvert.DefaultSettings = () =>
            {
                var settings = new JsonSerializerSettings
                {
                    ContractResolver = new CamelCasePropertyNamesContractResolver(),
                    FloatParseHandling = FloatParseHandling.Decimal
                };

                settings.Converters.Add(new StringEnumConverter());

                return settings;
            };
        }
    }
}
