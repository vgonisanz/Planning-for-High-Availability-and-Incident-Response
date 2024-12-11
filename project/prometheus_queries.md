## Availability SLI

### The percentage of successful requests over the last 5m

Lets use a Stat panel (as 100%) considering error is 5xx; 2xx, 4xx are successful:

sum(rate(flask_http_request_total{status!~"5.."}[5m]))/ sum(rate(flask_http_request_total[5m]))*100

## Latency SLI

### 90% of requests finish in these times

Lets use a time series with histogram quantiles of request duration:

histogram_quantile(0.95, sum by(le)(rate(flask_http_request_duration_seconds_bucket[30s])))

## Throughput

### Successful requests per second

Lets use a time series with the rate of successful requests over the last 5 minutes:

sum(rate(flask_http_request_total{status!~"5.."}[5m]))

## Error Budget - Remaining Error Budget

### The error budget is 20%

The error budget is defined as 20% of the total requests.
The remaining error budget is calculated as:

1 - (
      (1 - (
            sum(
              increase(flask_http_request_total{status!~"5.."}[7d])
            ) by (verb)
            /
            sum(
              increase(flask_http_request_total[7d])
            ) by (verb)
          )
      )
      /
      (1 - 0.80)
    )

## Notes

The app is using the following prometheus metrics:

- Histogram: flask_http_request_duration_seconds
- Counter: flask_http_request_total
- Counter: flask_http_request_exceptions_total
- Gauge: flask_exporter_info

Some help [here](https://github.com/rycus86/prometheus_flask_exporter/tree/master/examples/sample-signals)
