use qtbridge::include_bytes_qml;


pub fn init(){
    include_bytes_qml!("qml/Main.qml");
    include_bytes_qml!("qtquickcontrols2.conf");
    include_bytes_qml!("+windows/qtquickcontrols2.conf");
    include_bytes_qml!("+macos/qtquickcontrols2.conf");
}
