#[derive(Debug, Clone)]
pub struct Telemetry {
    pub device: String,
    pub signal_dbm: i8,
    pub noise_dbm: i8,
    pub snr_db: i8,
}
