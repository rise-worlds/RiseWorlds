use tokio::io::{self, AsyncWriteExt, AsyncReadExt};
use tokio::fs::File;

#[tokio::main]
async fn main() -> io::Result<()> {
    
    {
        let mut file = File::create("foo.txt").await?;

        // Writes some prefix of the byte string, but not necessarily all of it.
        let n = file.write(b"some bytes").await?;

        println!("Wrote the first {} bytes of 'some bytes'.", n);
    }
    {
        let mut f = File::open("foo.txt").await?;
        let mut buffer = Vec::new();

        // read the whole file
        let n = f.read_to_end(&mut buffer).await?;
        println!("The bytes: {:?}", &buffer[..n]);
    }

    Ok(())
}