import 'package:turkbelge_application/services/Banks/XmlParse.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

class DummyDataResponse {
  static final response = ''' 
<BankTransactionResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <ArrayOfAccounts>
    <Account>
      <AccountIban>TR440001000711829964725001</AccountIban>
      <BranchName>BUCA/İZMİR ŞUBESİ</BranchName>
      <AvailableBalance>25.63</AvailableBalance>
      <ArrayOfTransactions>
        <TransactionIban>TR570001000606000066667310</TransactionIban>
        <TransactionDateTime>7/12/2021 3:00:16 PM</TransactionDateTime>
        <TransactionName>TÜRKİYE HAYAT VE EMEKLİLİK ANONİM ŞİRKETİ</TransactionName>
        <TransactionAmount>7.00</TransactionAmount>
        <TransactionDescription>3481954 Dosya Referanslı Otomatik Katılım Ödemesi</TransactionDescription>
        <TransactionCode>XXX</TransactionCode>
        <BorcAlacak>B</BorcAlacak>
        <CurrencyType>TRY</CurrencyType>
        <RemainingBalance>                   -5.04</RemainingBalance>
      </ArrayOfTransactions>
      <ArrayOfTransactions>
        <TransactionIban>TR480006200086500006295003</TransactionIban>
        <TransactionDateTime>7/12/2021 5:31:27 PM</TransactionDateTime>
        <TransactionName>İLEKA AKADEMİ EĞİTİM DANIŞMANLIK VE</TransactionName>
        <TransactionAmount>1595.00</TransactionAmount>
        <TransactionDescription>İLEKA AKADEMİ EĞİTİM DANIŞMANLIK VE İLEKA AKADEMİ EĞİTİM DANIŞMANLIK VE / 0711EFTI21101747 Referanslı Gelen Havale Ödeme</TransactionDescription>
        <TransactionCode>TRF</TransactionCode>
        <BorcAlacak>A</BorcAlacak>
        <CurrencyType>TRY</CurrencyType>
        <RemainingBalance>                 1589.96</RemainingBalance>
      </ArrayOfTransactions>
      <ArrayOfTransactions>
        <TransactionIban>TR570001000606000066667310</TransactionIban>
        <TransactionDateTime>7/12/2021 6:00:10 PM</TransactionDateTime>
        <TransactionName>TÜRKİYE HAYAT VE EMEKLİLİK ANONİM ŞİRKETİ</TransactionName>
        <TransactionAmount>76.00</TransactionAmount>
        <TransactionDescription>3482099 Dosya Referanslı Otomatik Katılım Ödemesi</TransactionDescription>
        <TransactionCode>XXX</TransactionCode>
        <BorcAlacak>B</BorcAlacak>
        <CurrencyType>TRY</CurrencyType>
        <RemainingBalance>                 1513.96</RemainingBalance>
      </ArrayOfTransactions>
      <ArrayOfTransactions>
        <TransactionIban>TR570001000606000066667310</TransactionIban>
        <TransactionDateTime>7/12/2021 6:00:11 PM</TransactionDateTime>
        <TransactionName>TÜRKİYE HAYAT VE EMEKLİLİK ANONİM ŞİRKETİ</TransactionName>
        <TransactionAmount>152.00</TransactionAmount>
        <TransactionDescription>3482019 Dosya Referanslı Otomatik Katılım Ödemesi</TransactionDescription>
        <TransactionCode>XXX</TransactionCode>
        <BorcAlacak>B</BorcAlacak>
        <CurrencyType>TRY</CurrencyType>
        <RemainingBalance>                 1361.96</RemainingBalance>
      </ArrayOfTransactions>
      <ArrayOfTransactions>
        <TransactionIban>TR570001000606000066667310</TransactionIban>
        <TransactionDateTime>7/12/2021 6:00:15 PM</TransactionDateTime>
        <TransactionName>TÜRKİYE HAYAT VE EMEKLİLİK ANONİM ŞİRKETİ</TransactionName>
        <TransactionAmount>150.00</TransactionAmount>
        <TransactionDescription>3482151 Dosya Referanslı Otomatik Katılım Ödemesi</TransactionDescription>
        <TransactionCode>XXX</TransactionCode>
        <BorcAlacak>B</BorcAlacak>
        <CurrencyType>TRY</CurrencyType>
        <RemainingBalance>                 1211.96</RemainingBalance>
      </ArrayOfTransactions>
      <ArrayOfTransactions>
        <TransactionIban>TR570001000606000066667310</TransactionIban>
        <TransactionDateTime>7/12/2021 6:00:15 PM</TransactionDateTime>
        <TransactionName>TÜRKİYE HAYAT VE EMEKLİLİK ANONİM ŞİRKETİ</TransactionName>
        <TransactionAmount>152.00</TransactionAmount>
        <TransactionDescription>3481990 Dosya Referanslı Otomatik Katılım Ödemesi</TransactionDescription>
        <TransactionCode>XXX</TransactionCode>
        <BorcAlacak>B</BorcAlacak>
        <CurrencyType>TRY</CurrencyType>
        <RemainingBalance>                 1059.96</RemainingBalance>
      </ArrayOfTransactions>
      <ArrayOfTransactions>
        <TransactionIban>TR570001000606000066667310</TransactionIban>
        <TransactionDateTime>7/12/2021 6:00:15 PM</TransactionDateTime>
        <TransactionName>TÜRKİYE HAYAT VE EMEKLİLİK ANONİM ŞİRKETİ</TransactionName>
        <TransactionAmount>152.00</TransactionAmount>
        <TransactionDescription>3482065 Dosya Referanslı Otomatik Katılım Ödemesi</TransactionDescription>
        <TransactionCode>XXX</TransactionCode>
        <BorcAlacak>B</BorcAlacak>
        <CurrencyType>TRY</CurrencyType>
        <RemainingBalance>                  907.96</RemainingBalance>
      </ArrayOfTransactions>
      <ArrayOfTransactions>
        <TransactionIban>TR570001000606000066667310</TransactionIban>
        <TransactionDateTime>7/12/2021 6:00:15 PM</TransactionDateTime>
        <TransactionName>TÜRKİYE HAYAT VE EMEKLİLİK ANONİM ŞİRKETİ</TransactionName>
        <TransactionAmount>152.00</TransactionAmount>
        <TransactionDescription>3482023 Dosya Referanslı Otomatik Katılım Ödemesi</TransactionDescription>
        <TransactionCode>XXX</TransactionCode>
        <BorcAlacak>B</BorcAlacak>
        <CurrencyType>TRY</CurrencyType>
        <RemainingBalance>                  755.96</RemainingBalance>
      </ArrayOfTransactions>
      <ArrayOfTransactions>
        <TransactionIban>TR570001000606000066667310</TransactionIban>
        <TransactionDateTime>7/12/2021 6:00:16 PM</TransactionDateTime>
        <TransactionName>TÜRKİYE HAYAT VE EMEKLİLİK ANONİM ŞİRKETİ</TransactionName>
        <TransactionAmount>85.00</TransactionAmount>
        <TransactionDescription>3485973 Dosya Referanslı Otomatik Katılım Ödemesi</TransactionDescription>
        <TransactionCode>XXX</TransactionCode>
        <BorcAlacak>B</BorcAlacak>
        <CurrencyType>TRY</CurrencyType>
        <RemainingBalance>                  670.96</RemainingBalance>
      </ArrayOfTransactions>
      <ArrayOfTransactions>
        <TransactionIban>TR570001000606000066667310</TransactionIban>
        <TransactionDateTime>7/12/2021 6:00:16 PM</TransactionDateTime>
        <TransactionName>TÜRKİYE HAYAT VE EMEKLİLİK ANONİM ŞİRKETİ</TransactionName>
        <TransactionAmount>152.00</TransactionAmount>
        <TransactionDescription>3482006 Dosya Referanslı Otomatik Katılım Ödemesi</TransactionDescription>
        <TransactionCode>XXX</TransactionCode>
        <BorcAlacak>B</BorcAlacak>
        <CurrencyType>TRY</CurrencyType>
        <RemainingBalance>                  518.96</RemainingBalance>
      </ArrayOfTransactions>
      <ArrayOfTransactions>
        <TransactionIban>TR570001000606000066667310</TransactionIban>
        <TransactionDateTime>7/12/2021 6:00:16 PM</TransactionDateTime>
        <TransactionName>TÜRKİYE HAYAT VE EMEKLİLİK ANONİM ŞİRKETİ</TransactionName>
        <TransactionAmount>88.00</TransactionAmount>
        <TransactionDescription>3485984 Dosya Referanslı Otomatik Katılım Ödemesi</TransactionDescription>
        <TransactionCode>XXX</TransactionCode>
        <BorcAlacak>B</BorcAlacak>
        <CurrencyType>TRY</CurrencyType>
        <RemainingBalance>                  430.96</RemainingBalance>
      </ArrayOfTransactions>
      <ArrayOfTransactions>
        <TransactionIban>TR570001000606000066667310</TransactionIban>
        <TransactionDateTime>7/12/2021 6:00:16 PM</TransactionDateTime>
        <TransactionName>TÜRKİYE HAYAT VE EMEKLİLİK ANONİM ŞİRKETİ</TransactionName>
        <TransactionAmount>152.00</TransactionAmount>
        <TransactionDescription>3482037 Dosya Referanslı Otomatik Katılım Ödemesi</TransactionDescription>
        <TransactionCode>XXX</TransactionCode>
        <BorcAlacak>B</BorcAlacak>
        <CurrencyType>TRY</CurrencyType>
        <RemainingBalance>                  278.96</RemainingBalance>
      </ArrayOfTransactions>
      <ArrayOfTransactions>
        <TransactionIban>TR570001000606000066667310</TransactionIban>
        <TransactionDateTime>7/12/2021 6:00:17 PM</TransactionDateTime>
        <TransactionName>TÜRKİYE HAYAT VE EMEKLİLİK ANONİM ŞİRKETİ</TransactionName>
        <TransactionAmount>74.00</TransactionAmount>
        <TransactionDescription>3482080 Dosya Referanslı Otomatik Katılım Ödemesi</TransactionDescription>
        <TransactionCode>XXX</TransactionCode>
        <BorcAlacak>B</BorcAlacak>
        <CurrencyType>TRY</CurrencyType>
        <RemainingBalance>                  204.96</RemainingBalance>
      </ArrayOfTransactions>
      <ArrayOfTransactions>
        <TransactionIban>TR570001000606000066667310</TransactionIban>
        <TransactionDateTime>7/14/2021 10:00:13 AM</TransactionDateTime>
        <TransactionName>TÜRKİYE HAYAT VE EMEKLİLİK ANONİM ŞİRKETİ</TransactionName>
        <TransactionAmount>88.00</TransactionAmount>
        <TransactionDescription>3486001 Dosya Referanslı Otomatik Katılım Ödemesi</TransactionDescription>
        <TransactionCode>XXX</TransactionCode>
        <BorcAlacak>B</BorcAlacak>
        <CurrencyType>TRY</CurrencyType>
        <RemainingBalance>                  116.96</RemainingBalance>
      </ArrayOfTransactions>
      <ArrayOfTransactions>
        <TransactionIban>TR570001000606000066667310</TransactionIban>
        <TransactionDateTime>7/14/2021 10:00:16 AM</TransactionDateTime>
        <TransactionName>TÜRKİYE HAYAT VE EMEKLİLİK ANONİM ŞİRKETİ</TransactionName>
        <TransactionAmount>111.00</TransactionAmount>
        <TransactionDescription>3481975 Dosya Referanslı Otomatik Katılım Ödemesi</TransactionDescription>
        <TransactionCode>XXX</TransactionCode>
        <BorcAlacak>B</BorcAlacak>
        <CurrencyType>TRY</CurrencyType>
        <RemainingBalance>                    5.96</RemainingBalance>
      </ArrayOfTransactions>
    </Account>
  </ArrayOfAccounts>
</BankTransactionResponse>''';

}
