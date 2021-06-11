import { HttpClient, HttpHeaders } from "@angular/common/http";

export class AbstractService {
    protected headers: HttpHeaders;
    protected authHeaders: HttpHeaders;

    constructor(
        protected http: HttpClient
    ) {
        this.headers = new HttpHeaders({
            "Content-Type": "application/json"
        });

        
        this.authHeaders = new HttpHeaders({
            "Content-Type": "application/json"
        });
    }
}