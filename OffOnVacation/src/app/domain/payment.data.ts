/**
 * Created by Nick on 7/11/2017.
 */
export class PaymentData {
  card_type: string; //Visa, Mastercard, etc.
  card_number: number;
  cvv: number;
  expiration_date: string;
  billing_zip: number;
  bill_addr_1: string;
  bill_addr_2: string;
  city: string;
  state: string;
}
